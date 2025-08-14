# RecipeBuddy

SwiftUI + MVVM app to browse recipes, view details, favorite, plan weekly meals, and auto-build a shopping list.

## How to Run
- Xcode 15+ / iOS 17+ (deployment target: 17.5)
- Open `RecipeBuddy.xcodeproj` and Run (iPhone-only is fine)
- No setup required (uses bundled `Resources/recipes.json` by default)

## Architecture & Trade-offs
- **MVVM** with **Repository** (`Local` bundle JSON + `Remote` URL) and **graceful fallback** (offline-first)
- **DependencyContainer** injects `repository`, `FavoritesStore`, `MealPlanStore`
- **Async/await**, debounced search, **no I/O in Views**
- **Image caching**: `NSCache` + `URLCache`; placeholder on failure
- Trade-offs: UserDefaults for lightweight persistence; iOS 18 Simulator can be flaky with HTTP/3—works fine on iOS 17.x / devices

## Features Completed
- **Level 1:** List, Detail (image + ingredients checklist), Search (debounced), Empty/Error states, Favorites (persisted)
- **Level 2:** Sort by minutes, Tag filters, Offline-first (source switch + fallback), Basic image caching, Unit tests (JSON + ViewModel)
- **Level 3:** Meal Plan (Mon–Sun), Shopping List (consolidated), Share list
- **Bonus:** Clean DI, friendly empty states

## Tests & Coverage
- Run with **⌘U** (XCTest)
- Unit tests: JSON decoding, `RecipeListViewModel` (load/search/filter/sort)
- (Optional) Screenshots in `docs/` (tests & coverage)

## With More Time
- Persist ingredient checkmarks per recipe
- Prefetch images & tune disk cache
- SwiftData/Core Data variant for richer local data model

## Links
- Video: https://drive.google.com/file/d/1tyxVbaZsKwqyQ1PSgf3rO4m7KWRF9nTj/view?usp=sharing
