//
//  RemoteRecipeRepository.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import Foundation

struct RemoteRecipeRepository {
    let url: URL?

    init(urlString: String) { self.url = URL(string: urlString) }

    func load() async throws -> [Recipe] {
        guard let url else { throw URLError(.badURL) }
        let (data, resp) = try await URLSession.shared.data(from: url)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        return try JSONDecoder().decode([Recipe].self, from: data)
    }
}
