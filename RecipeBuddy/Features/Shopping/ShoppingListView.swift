//
//  ShoppingListView.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 14/08/25.
//

import SwiftUI

struct ShoppingListView: View {
    @StateObject var viewModel = ShoppingListViewModel()
    let recipes: [Recipe]

    var body: some View {
        VStack {
            if !viewModel.items.isEmpty {
                List(viewModel.items) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.name).font(.headline)
                        Text(item.lines.joined(separator: ", "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            } else {
                VStack(spacing: 8) {
                    Text("No items")
                        .font(.headline)
                    Text("Add recipes to your weekly plan to get shopping list")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .toolbar {
            ShareLink("Share", item: viewModel.shareText())
        }
        .navigationTitle("Shopping List")
        .onAppear { viewModel.build(from: recipes) }
    }
}
