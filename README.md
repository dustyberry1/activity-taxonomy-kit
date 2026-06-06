# ActivityTaxonomyKit

Reusable Swift package for activity taxonomies and icon matching.

## What this gives you

- A small, opinionated activity catalog that is easy to replace or extend
- Stable API to look up activity names, ids, categories, and icons
- Heuristic icon suggestion and search for activity names

This is intentionally a small building block, not a full health domain stack.

## Install

### Swift Package Manager

Add this package to your `Package.swift` or Xcode package dependency.

```swift
let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/your-org/activity-taxonomy-kit", from: "0.1.0")
    ]
)
```

## Quick start

```swift
import ActivityTaxonomyKit

let catalog = BuiltInActivityCatalog.builtIn()
let stressName = catalog.displayName(for: "stress")
let stressIcon = catalog.iconName(for: "stress")

let iconMatcher = ActivityIconMatcher(iconNames: ["coffee", "wine", "brain", "workout", "bed", "sparkle"])
let suggested = iconMatcher.suggestIcon(for: "Evening coffee")
let matches = iconMatcher.search(query: "cof")
```

## API

- `BuiltInActivityCatalog`
  - `activity(for:)`
  - `activity(by:)`
  - `allActivities()`
  - `activities(in:)`
  - `displayName(for:)`
  - `insightDisplayName(for:preferredName:)`
  - `iconName(for:)`
  - `search(query:)`
- `ActivityIconMatcher`
  - `suggestIcon(for:)`
  - `search(query:)`
  - `allIcons()`

## Roadmap

- Add JSON-driven catalogs and external catalog loading.
- Add richer ranking metrics for suggestions.
- Add SwiftUI sample picker component.

