//
//  RecipeRowView.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            CachedAsyncImage(url: recipe.image)
                .frame(width: 80, height: 60)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title).font(.headline).lineLimit(1)
                Text("\(recipe.minutes) min (\((recipe.tags.joined(separator: ", ")).capitalized))")
                    .font(.caption).foregroundStyle(.secondary).lineLimit(1)
            }
            Spacer()
            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(Color(.systemRed))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
    }
}
