//
//  RecipeDetailViewModel.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import Foundation

@MainActor
final class RecipeDetailViewModel: ObservableObject {
    let recipe: Recipe
    @Published var obtained: Set<Int> = []
    @Published var isFavorite: Bool
    
    private let onToggleFavorite: () -> Void
    
    init(recipe: Recipe, favorites: Bool, onToggleFavorite: @escaping () -> Void) {
        self.recipe = recipe
        self.isFavorite = favorites
        self.onToggleFavorite = onToggleFavorite
    }
    
    func toggleFavorite() {
        onToggleFavorite()
        isFavorite.toggle()
    }
    
    func toggleObtained(_ index: Int) {
        if obtained.contains(index) { obtained.remove(index) } else { obtained.insert(index) }
    }
}
