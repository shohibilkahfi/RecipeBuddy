//
//  RecipeListViewModelTests.swift
//  RecipeBuddyTests
//
//  Created by Orenda M1 on 14/08/25.
//

import XCTest
@testable import RecipeBuddy

final class MockRepo: RecipeRepository {
    var dataSource: DataSource = .local
    let data: [Recipe]
    init(_ data: [Recipe]) { self.data = data }
    func fetchRecipes() async throws -> [Recipe] { data }
}

private let samples: [Recipe] = [
    Recipe(id: "r1", title: "Garlic Lemon Chicken", tags: ["quick","protein"], image: URL(string: "https://example.com/1.png"), minutes: 25,
           ingredients: [Ingredient(name: "Garlic", quantity: "3 cloves")],
           steps: ["A","B"]),
    Recipe(id: "r2", title: "Veggie Pasta", tags: ["vegetarian","family"], image: URL(string: "https://example.com/2.png"), minutes: 30,
           ingredients: [Ingredient(name: "Pasta", quantity: "200 g")],
           steps: ["A","B"]),
    Recipe(id: "r3", title: "Overnight Oats", tags: ["breakfast","quick"], image: URL(string: "https://example.com/3.png"), minutes: 10,
           ingredients: [Ingredient(name: "Milk", quantity: "1/2 cup")],
           steps: ["A","B"]),
]

@MainActor
final class RecipeListViewModelTests: XCTestCase {
    private func makeVM() -> RecipeListViewModel {
        RecipeListViewModel(
            repository: MockRepo(samples),
            favorites: FavoritesStore(),
            mealPlan: MealPlanStore()
        )
    }

    func testLoadAndDefaultSortAscending() async throws {
        let vm = makeVM()
        await vm.load()
        XCTAssertEqual(vm.filtered.map(\.minutes), [10,25,30])
    }

    func testSearchByTitle() async throws {
        let vm = makeVM()
        await vm.load()
        vm.searchText = "oats"
        vm.applyFilters()
        XCTAssertEqual(vm.filtered.map(\.id), ["r3"])
    }

    func testSearchByIngredient() async throws {
        let vm = makeVM()
        await vm.load()
        vm.searchText = "garlic"
        vm.applyFilters()
        XCTAssertEqual(vm.filtered.map(\.id), ["r1"])
    }

    func testTagFilterAndSortDesc() async throws {
        let vm = makeVM()
        await vm.load()
        vm.selectedTags = ["quick"]
        vm.sortAscending = false
        vm.applyFilters()
        XCTAssertEqual(vm.filtered.map(\.id), ["r1","r3"]) // 25, 10
    }
}
