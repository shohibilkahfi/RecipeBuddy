//
//  RecipeRepository.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import Foundation

enum DataSource { case local, remote }

protocol RecipeRepository {
    var dataSource: DataSource { get set }
    func fetchRecipes() async throws -> [Recipe]
}
