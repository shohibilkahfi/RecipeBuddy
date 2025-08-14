//
//  DependencyContainer.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import Foundation

@MainActor
final class DependencyContainer: ObservableObject {
    let favorites = FavoritesStore()
    let mealPlan  = MealPlanStore()

    private let local  = LocalRecipeRepository()
    private let remote = RemoteRecipeRepository(
        urlString: "https://raw.githubusercontent.com/youruser/yourrepo/main/recipes.json"
    )

    lazy var repository: RecipeRepository = FallbackRecipeRepository(local: local, remote: remote)
}
