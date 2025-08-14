//
//  RecipeListView.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel: RecipeListViewModel
    @EnvironmentObject private var mealPlan: MealPlanStore

    var body: some View {
        VStack {
            Picker("Source", selection: $viewModel.dataSource) {
                Text("Local").tag(DataSource.local)
                Text("Remote").tag(DataSource.remote)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            TextField("Search by title or ingredient…", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .onChange(of: viewModel.searchText) {
                    viewModel.onSearchChange(viewModel.searchText)
                }
                .padding(.vertical, 8)

            // Filters + Sort
            HStack {
                TagChipsView(all: viewModel.allTags, selected: $viewModel.selectedTags)
                    .onChange(of: viewModel.selectedTags) {
                        viewModel.applyFilters()
                    }
                Spacer()
                Button {
                    viewModel.sortAscending.toggle()
                    viewModel.applyFilters()
                } label: {
                    Image(systemName: viewModel.sortAscending ? "arrow.up" : "arrow.down")
                    Text("Sort by Time")
                        .font(.caption)
                }
            }
            .padding(.horizontal)

            content
        }
        .navigationTitle("Recipe Buddy")
        .task { await viewModel.load() }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink {
                    MealPlanView(recipes: viewModel.recipes)
                } label: {
                    Image(systemName: "calendar")
                }
                
                NavigationLink {
                    ShoppingListView(recipes: plannedRecipes())
                } label: {
                    Image(systemName: "cart")
                }
            }
        }
    }
    
    private func plannedRecipes() -> [Recipe] {
        let plannedIDs = Set(mealPlan.plan.values.flatMap { $0 })
        return viewModel.recipes.filter { plannedIDs.contains($0.id) }
    }

    @ViewBuilder private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .error(let msg):
            VStack(spacing: 8) {
                Text("Something went wrong").font(.headline)
                Text(msg).foregroundStyle(.secondary).multilineTextAlignment(.center)
                Button("Retry") {
                    Task { await viewModel.load() }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .empty:
            VStack(spacing: 8) {
                Text("No results")
                    .font(.headline)
                Text("Try clearing filters or changing your search.")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded:
            List(viewModel.filtered, id: \.id) { recipe in
                NavigationLink {
                    RecipeDetailView(
                        viewModel: .init(
                            recipe: recipe,
                            favorites: viewModel.isFavorite(recipe.id),
                            onToggleFavorite: { viewModel.toggleFavorite(recipe.id) }
                        )
                    )
                } label: {
                    RecipeRowView(
                        recipe: recipe,
                        isFavorite: viewModel.isFavorite(recipe.id),
                        onToggleFavorite: { viewModel.toggleFavorite(recipe.id) }
                    )
                }
            }
            .listStyle(.plain)
        }
    }
}
