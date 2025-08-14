//
//  MealPlanView.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 14/08/25.
//

import SwiftUI

struct MealPlanView: View {
    @EnvironmentObject private var mealPlan: MealPlanStore
    let recipes: [Recipe]

    private func recipesFor(_ day: Weekday) -> [Recipe] {
        let ids = Set(mealPlan.plan[day] ?? [])
        return recipes.filter { ids.contains($0.id) }
    }

    var body: some View {
        List {
            ForEach(Weekday.allCases) { day in
                Section(day.list) {
                    let list = recipesFor(day)
                    if list.isEmpty {
                        Text("No recipes added")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(list, id: \.id) { recipe in
                            HStack {
                                Text(recipe.title)
                                Spacer()
                                Button {
                                    mealPlan.remove(recipe.id, from: day)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundStyle(Color(.systemRed))
                                }

                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("This Week’s Plan")
    }
}
