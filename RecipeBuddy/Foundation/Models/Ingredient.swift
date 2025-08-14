//
//  Ingredient.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import Foundation

struct Ingredient: Codable, Hashable {
    let name: String
    let quantity: String?
    var display: String {
        if let q = quantity, !q.isEmpty { return "\(q) \(name)" }
        return name
    }
}
