# ActivityTaxonomyKit

Reusable Swift package for activity taxonomies and icon matching.

## What this gives you

- A small, opinionated activity catalog that is easy to replace or extend
- Stable API to look up activity names, ids, categories, and icons
- Heuristic icon suggestion and search for activity names
- Swappable catalog data loaded from JSON so your defaults can be customized in-app
- A compact SwiftUI demo for searching and browsing icon names

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

## JSON catalog loading

The default catalog is bundled as `activity-catalog.json` and can be swapped in consuming apps by loading any catalog JSON file with the same schema.

```swift
let customCatalogURL: URL = ...
let customCatalog = try BuiltInActivityCatalog.load(contentsOf: customCatalogURL)
```

Resource-based loading is also available:

```swift
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

`category` values must match `ActivityCategory` raw values.

## SwiftUI demo

If SwiftUI is available, use the demo view:

```swift
import SwiftUI
import ActivityTaxonomyKit

struct DemoHost: View {
    var body: some View {
        ActivityIconDemoView()
    }
}
```

## API

- `BuiltInActivityCatalog`
  - `activity(for:)`
  - `activity(by:)`
  - `builtIn()`
  - `load(resourceName:in:)`
  - `load(contentsOf:)`
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
- `ActivityIconDemoView`

## Roadmap

- Add richer ranking metrics for suggestions.
