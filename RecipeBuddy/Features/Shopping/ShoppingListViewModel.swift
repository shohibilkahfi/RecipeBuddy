//
//  ShoppingListViewModel.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 14/08/25.
//

import Foundation

struct ShoppingItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var lines: [String]
}

@MainActor
final class ShoppingListViewModel: ObservableObject {
    @Published private(set) var items: [ShoppingItem] = []

    func build(from planned: [Recipe]) {
        var map: [String: [String]] = [:]
        for r in planned {
            for ing in r.ingredients {
                let key = ing.name.lowercased()
                let line = ing.display
                map[key, default: []].append(line)
            }
        }
        items = map.map { ShoppingItem(name: $0.key.capitalized, lines: $0.value) }
                   .sorted { $0.name < $1.name }
    }

    func shareText() -> String {
        items.map { item in
            let joined = item.lines.joined(separator: ", ")
            return "- \(item.name): \(joined)"
        }.joined(separator: "\n")
    }
}
