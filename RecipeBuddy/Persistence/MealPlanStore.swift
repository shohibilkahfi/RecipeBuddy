//
//  MealPlanStore.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import Foundation

enum Weekday: String, CaseIterable, Identifiable {
    case mon, tue, wed, thu, fri, sat, sun
    var id: String { rawValue }
    var list: String {
        switch self {
        case .mon:
            "Monday"
        case .tue:
            "Tuesday"
        case .wed:
            "Wednesday"
        case .thu:
            "Thursday"
        case .fri:
            "Friday"
        case .sat:
            "Saturday"
        case .sun:
            "Sunday"
        }
    }
}

@MainActor
final class MealPlanStore: ObservableObject {
    @Published private(set) var plan: [Weekday: [String]] = [:]
    private let key = "meal_plan_v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([String: [String]].self, from: data) {
            plan = Dictionary(uniqueKeysWithValues: decoded.compactMap { (Weekday(rawValue: $0.key), $0.value) }.compactMap { wd, ids in wd.map { ($0, ids) } })
        }
    }

    func add(_ recipeID: String, to day: Weekday) {
        var arr = plan[day] ?? []
        if !arr.contains(recipeID) { arr.append(recipeID) }
        plan[day] = arr
        persist()
    }

    func remove(_ recipeID: String, from day: Weekday) {
        plan[day]?.removeAll { $0 == recipeID }
        persist()
    }

    private func persist() {
        let enc = Dictionary(uniqueKeysWithValues: plan.map { ($0.key.rawValue, $0.value) })
        let data = try? JSONEncoder().encode(enc)
        UserDefaults.standard.set(data, forKey: key)
    }
}
