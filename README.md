# ActivityTaxonomyKit

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platforms-iOS%2017%20%7C%20macOS%2014-blue.svg)](https://developer.apple.com/swift/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![CI](https://github.com/dustyberry1/activity-taxonomy-kit/actions/workflows/swift.yml/badge.svg)](https://github.com/dustyberry1/activity-taxonomy-kit/actions/workflows/swift.yml)

Reusable Swift package for activity taxonomies and SF Symbol icon matching. A small, focused building block for health and wellness apps that need a standardized, swappable catalog of trackable activities.

## Why this matters

Health apps frequently reinvent the same wheel: a list of things a person can track (stress, sleep, hydration, exercise…), human-readable names for them, and icon suggestions to go with them. Every team writes this from scratch, names things inconsistently, and ends up with variable keys like `"stressLevel"`, `"stress_lvl"`, and `"Stress"` spread across their codebase.

ActivityTaxonomyKit gives you:

- **Stable variable keys** — `"stress"`, `"hydration"`, `"sleep"` — that you can use as dictionary keys, HealthKit identifiers, or analytics event names without worrying about typos
- **A JSON-driven catalog** you can swap per-user or per-app-version without shipping new code
- **Icon matching that actually works** — tokenising both the activity name and SF Symbol names so `"Evening coffee"` reliably suggests `"cup.and.saucer.fill"`
- **Zero dependencies** beyond Foundation and optional SwiftUI

If you're building a journal, symptom tracker, wellness coach, or research data-collection app, this package handles the taxonomy layer so you can focus on the product.

## Who this is for

| Role | How you'd use it |
|---|---|
| iOS / macOS app developer | Drop in the catalog, use variable keys as stable identifiers throughout your app |
| Health app indie dev | Customise the JSON catalog with your own activities without forking |
| Research / clinical tool builder | Use `BuiltInActivityCatalog.search(query:)` to power a participant-facing activity picker |
| Design system author | Use `ActivityIconMatcher` to auto-suggest SF Symbols for user-defined tracking items |

## What this gives you

- A bundled catalog of 31 activities across 7 categories — easy to replace or extend with your own JSON
- Stable API to look up activity names, ids, categories, and SF Symbol icon names
- Heuristic icon suggestion and fuzzy search for activity names
- Swappable catalog data loaded from JSON so defaults can be customized in-app without code changes
- A compact SwiftUI demo for searching and browsing icon names

This is intentionally a small building block, not a full health domain stack.

## Install

### Swift Package Manager

Add to your `Package.swift`:

```swift
let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/dustyberry1/activity-taxonomy-kit", from: "0.1.0")
    ],
    targets: [
        .target(name: "YourTarget", dependencies: ["ActivityTaxonomyKit"])
    ]
)
```

Or add via Xcode: **File → Add Package Dependencies** and paste the repo URL.

## Quick start

### Look up activities from the built-in catalog

```swift
import ActivityTaxonomyKit

let catalog = BuiltInActivityCatalog.builtIn()

// Stable display name and icon for a variable key
let name = catalog.displayName(for: "stress")   // "Stress"
let icon = catalog.iconName(for: "stress")      // "brain"

// Browse all activities in a category
let foodItems = catalog.activities(in: .foodAndDrink)
for item in foodItems {
    print("\(item.name) → \(item.iconFilename)")
    // "Caffeine → cup.and.saucer.fill"
    // "Alcohol → wineglass"
    // ...
}
```

### Power a search-as-you-type picker

```swift
let catalog = BuiltInActivityCatalog.builtIn()

// Full-text search across names and keys — good for a UISearchBar / .searchable
let results = catalog.search(query: "sleep")
// → [ActivityEntry(id: "sleep", name: "Sleep", category: .bodyAndPhysicalState, …)]
```

### Suggest an SF Symbol for a user-defined activity

```swift
// Works with any SF Symbol list — pass the symbols your app already uses
let allSymbols = UIImage.systemImageNames  // or your own curated list
let matcher = ActivityIconMatcher(iconNames: allSymbols)

matcher.suggestIcon(for: "Morning run")       // "figure.run"
matcher.suggestIcon(for: "Evening coffee")    // "cup.and.saucer.fill"
matcher.suggestIcon(for: "Anxiety check-in")  // "brain.head.profile"

// Fuzzy search for an icon picker UI
let hits = matcher.search(query: "heart")
// → ["heart", "heart.fill", "heart.circle", …]
```

### Load a custom catalog (e.g. from your server)

```swift
// Swap in a per-user or per-study catalog without changing code
let url = Bundle.main.url(forResource: "study-catalog", withExtension: "json")!
let catalog = try BuiltInActivityCatalog.load(contentsOf: url)
```

## Architecture

```
ActivityTaxonomyKit
├── ActivityEntry          — Codable struct: id, name, variableKey, category, iconFilename, sortOrder
├── ActivityCategory       — Enum of 7 categories (stress, foodAndDrink, movement, …)
├── BuiltInActivityCatalog — Main query surface; loads JSON from bundle or custom URLs
├── ActivityIconMatcher    — Tokenising heuristic engine for icon suggestion & fuzzy search
├── ActivityIconDemoView   — SwiftUI demo (conditionally compiled; requires SwiftUI)
└── Resources/
    └── activity-catalog.json  — Bundled catalog, schema "activity-taxonomy-catalog-v1"
```

`BuiltInActivityCatalog` owns the catalog data and exposes read-only lookups. `ActivityIconMatcher` is independent — instantiate it with any list of SF Symbol names from your app.

## JSON catalog loading

The default catalog is bundled as `activity-catalog.json` and can be swapped in consuming apps:

```swift
// Load from an arbitrary URL (e.g. downloaded from your server)
let customCatalog = try BuiltInActivityCatalog.load(contentsOf: customCatalogURL)

// Load from a named resource in any bundle
let catalog = try BuiltInActivityCatalog.load(resourceName: "my-catalog", in: Bundle.main)
```

### Schema

```json
{
  "schema": "activity-taxonomy-catalog-v1",
  "version": "1.0",
  "activities": [
    {
      "id": "hydration",
      "name": "Hydration",
      "variableKey": "hydration",
      "category": "bodyAndPhysicalState",
      "iconFilename": "drop",
      "defaultSortOrder": 1
    }
  ]
}
```

`category` must be one of: `stress`, `foodAndDrink`, `movement`, `bodyAndPhysicalState`, `medical`, `hormonal`, `protectiveAndPositive`

## SwiftUI demo

```swift
import SwiftUI
import ActivityTaxonomyKit

struct DemoHost: View {
    var body: some View {
        ActivityIconDemoView()
    }
}
```

`ActivityIconDemoView` is conditionally compiled and only available when SwiftUI is present.

## API reference

### `BuiltInActivityCatalog`

| Method | Description |
|---|---|
| `builtIn()` | Load the bundled catalog |
| `load(resourceName:in:)` | Load from a named bundle resource |
| `load(contentsOf:)` | Load from a file URL |
| `activity(for:)` | Look up by variable key |
| `activity(by:)` | Look up by activity id |
| `allActivities()` | All activities, sorted by `defaultSortOrder` |
| `activities(in:)` | All activities in a given category |
| `displayName(for:)` | Display name string for a variable key |
| `insightDisplayName(for:preferredName:)` | Display name with an optional override |
| `iconName(for:)` | SF Symbol name for a variable key |
| `search(query:)` | Full-text search across names and keys |

### `ActivityIconMatcher`

| Method | Description |
|---|---|
| `suggestIcon(for:)` | Heuristic best-match icon for an activity name |
| `search(query:)` | Fuzzy search over icon names |
| `allIcons()` | All registered icon names |

## Roadmap

- [ ] Richer ranking metrics for icon suggestions (TF-IDF or edit distance)
- [ ] Localisation support for `displayName`
- [ ] SwiftUI catalog browser view (beyond the icon demo)
- [ ] Swift 6 / strict concurrency audit

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). PRs and issues are welcome — please keep contributions focused and include tests.

## License

MIT — see [LICENSE](LICENSE).
