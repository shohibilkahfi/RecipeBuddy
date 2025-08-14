//
//  RecipeBuddyApp.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import SwiftUI

@main
struct RecipeBuddyApp: App {
    @StateObject private var container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RecipeListView(
                    viewModel: .init(
                        repository: container.repository,
                        favorites: container.favorites,
                        mealPlan: container.mealPlan
                    )
                )
            }
            .environmentObject(container.favorites)
            .environmentObject(container.mealPlan)
        }
    }
}
