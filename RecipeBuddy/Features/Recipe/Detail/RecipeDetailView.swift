//
//  RecipeDetailView.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @StateObject var viewModel: RecipeDetailViewModel
    @EnvironmentObject private var mealPlan: MealPlanStore
    @State var showSuccess = false
    @State private var addedDay: Weekday?

    var body: some View {
        ScrollView {
            if let url = viewModel.recipe.image {
                CachedAsyncImage(url: url)
                    .frame(height: 220)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(viewModel.recipe.title).font(.title2).bold()
                    Spacer()
                    Button {
                        viewModel.toggleFavorite()
                    } label: {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(Color(.systemRed))
                    }.buttonStyle(.plain)
                }

                Text("\(viewModel.recipe.minutes) minutes")
                    .font(.subheadline).foregroundStyle(.secondary)

                // Tags
                TagChipsView(all: viewModel.recipe.tags, selected: .constant([]))
                    .allowsHitTesting(false)

                // Ingredients checklist
                Text("Ingredients")
                    .font(.headline)
                ForEach(Array(viewModel.recipe.ingredients.enumerated()), id: \.offset) { i, ing in
                    HStack {
                        Image(systemName: viewModel.obtained.contains(i) ? "checkmark.square.fill" : "square")
                            .foregroundStyle(Color.accentColor)
                            .onTapGesture { viewModel.toggleObtained(i) }
                        Text(ing.display)
                    }
                }

                // Steps
                Text("Method")
                    .font(.headline)
                    .padding(.top, 8)
                ForEach(Array(viewModel.recipe.steps.enumerated()), id: \.offset) { i, step in
                    HStack(alignment: .top) {
                        Text("\(i+1).").bold()
                        Text(step)
                    }
                }

                // Add to meal plan
                Menu("Add to This Week") {
                    ForEach(Weekday.allCases) { day in
                        Button(day.list) {
                            mealPlan.add(viewModel.recipe.id, to: day)
                            addedDay = day
                            Task { @MainActor in showSuccess = true }
                        }
                        
                    }
                }
            }
            .padding()
        }
        .alert("Added to This Week", isPresented: $showSuccess, presenting: addedDay, actions: { _ in
            Button("OK", role: .cancel) { }
        }, message: { day in
            Text("\(viewModel.recipe.title) added to \(day.list)")
        })
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
