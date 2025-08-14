//
//  AsyncDebouncer.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import Foundation

actor AsyncDebouncer {
    private var workItem: Task<Void, Never>?
    func debounce(milliseconds: Int, _ block: @escaping () async -> Void) {
        workItem?.cancel()
        workItem = Task {
            try? await Task.sleep(nanoseconds: UInt64(milliseconds) * 1_000_000)
            guard !Task.isCancelled else { return }
            await block()
        }
    }
}
