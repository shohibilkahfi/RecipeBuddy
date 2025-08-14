//
//  FallbackRecipeRepository.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import Foundation

final class FallbackRecipeRepository: RecipeRepository {
    var dataSource: DataSource = .local
    private let local: LocalRecipeRepository
    private let remote: RemoteRecipeRepository

    init(local: LocalRecipeRepository, remote: RemoteRecipeRepository) {
        self.local = local
        self.remote = remote
    }

    func fetchRecipes() async throws -> [Recipe] {
        switch dataSource {
        case .local:
            do { return try local.load() } catch {
                throw error
            }
        case .remote:
            do { return try await remote.load() }
            catch {
                return try local.load()
            }
        }
    }
}
