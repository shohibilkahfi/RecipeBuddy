//
//  LocalRecipeRepository.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import Foundation

struct LocalRecipeRepository {
    func load() throws -> [Recipe] {
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
            throw NSError(domain: "LocalRepo", code: 404, userInfo: [NSLocalizedDescriptionKey: "recipes.json not found"])
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Recipe].self, from: data)
    }
}
