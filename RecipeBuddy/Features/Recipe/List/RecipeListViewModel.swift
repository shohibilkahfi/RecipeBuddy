//
//  RecipeListViewModel.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import Foundation

@MainActor
final class RecipeListViewModel: ObservableObject {
    enum ViewState { case idle, loading, loaded, error(String), empty }

    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var filtered: [Recipe] = []
    @Published var searchText: String = ""
    @Published var selectedTags: Set<String> = []
    @Published var sortAscending: Bool = true
    @Published var state: ViewState = .idle
    @Published var dataSource: DataSource = .local {
        didSet { repository.dataSource = dataSource
            Task { await load() }
        }
    }

    private var repository: RecipeRepository
    private let favorites: FavoritesStore
    private let mealPlan: MealPlanStore
    private let debouncer = AsyncDebouncer()

    init(repository: RecipeRepository, favorites: FavoritesStore, mealPlan: MealPlanStore) {
        self.repository = repository
        self.favorites = favorites
        self.mealPlan = mealPlan
    }

    func load() async {
        state = .loading
        do {
            let items = try await repository.fetchRecipes()
            recipes = items
            applyFilters()
            state = filtered.isEmpty ? .empty : .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func toggleFavorite(_ id: String) {
        favorites.toggle(id)
        objectWillChange.send()
    }
    func isFavorite(_ id: String) -> Bool { favorites.contains(id) }

    func onSearchChange(_ text: String) {
        Task { await debouncer.debounce(milliseconds: 500) { [weak self] in self?.applyFilters() } }
    }

    func applyFilters() {
        var result = recipes

        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !q.isEmpty {
            result = result.filter { r in
                r.title.lowercased().contains(q) ||
                r.ingredients.contains { $0.name.lowercased().contains(q) }
            }
        }
        
        if !selectedTags.isEmpty {
            result = result.filter { !selectedTags.isDisjoint(with: Set($0.tags)) }
        }
        
        result.sort { sortAscending ? $0.minutes < $1.minutes : $0.minutes > $1.minutes }

        filtered = result
        switch state {
        case .loaded, .empty:
            state = filtered.isEmpty ? .empty : .loaded
        default:
            break
        }
    }

    var allTags: [String] { Array(Set(recipes.flatMap { $0.tags })).sorted() }
}
