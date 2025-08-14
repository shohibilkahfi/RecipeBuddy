//
//  Recipe.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import Foundation

struct Recipe: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let tags: [String]
    let image: URL?
    let minutes: Int
    let ingredients: [Ingredient]
    let steps: [String]
}
