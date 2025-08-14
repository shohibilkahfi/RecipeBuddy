//
//  CachedAsyncImage.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 14/08/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    @State private var image: UIImage?
    @State private var error: Error?

    private static let session: URLSession = {
        let cfg = URLSessionConfiguration.default
        cfg.requestCachePolicy = .returnCacheDataElseLoad
        cfg.urlCache = URLCache(memoryCapacity: 50*1024*1024, diskCapacity: 200*1024*1024)
        cfg.waitsForConnectivity = false
        cfg.timeoutIntervalForRequest = 15
        cfg.timeoutIntervalForResource = 30
        return URLSession(configuration: cfg)
    }()

    var body: some View {
        Group {
            if let ui = image {
                Image(uiImage: ui).resizable()
            } else if error != nil {
                Image(systemName: "photo")
            } else {
                ProgressView()
            }
        }
        .task(id: url) { await load() }
    }

    @MainActor
    private func load() async {
        guard let url else { return }
        if let cached = ImageCache.shared.object(forKey: url as NSURL) {
            image = cached
            return
        }

        do {
            var req = URLRequest(url: url)
            req.cachePolicy = .returnCacheDataElseLoad
            let (data, resp) = try await Self.session.data(for: req)
            guard (resp as? HTTPURLResponse)?.statusCode == 200,
                  let ui = UIImage(data: data) else { throw URLError(.badServerResponse) }
            ImageCache.shared.setObject(ui, forKey: url as NSURL)
            image = ui
        } catch {
            self.error = error
        }
    }
}
