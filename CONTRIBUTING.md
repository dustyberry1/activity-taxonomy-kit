# Contributing to ActivityTaxonomyKit

Thanks for your interest in contributing! This is a small, focused Swift package — contributions that keep it lean and well-tested are most welcome.

## What's in scope

- New activity entries or categories in `activity-catalog.json`
- Improvements to icon matching heuristics in `ActivityIconMatcher`
- Additional `BuiltInActivityCatalog` query methods
- Bug fixes and test coverage
- Documentation improvements

## What's out of scope

- Adding new package dependencies
- Networking or remote catalog fetching (this stays local/bundled)
- Health framework integration (keep the package domain-agnostic)

## Getting started

```bash
git clone https://github.com/dustyberry1/activity-taxonomy-kit
cd activity-taxonomy-kit
swift build
swift test
```

Requires Xcode 15+ or Swift 5.9+ toolchain.

## Making changes

1. Fork the repo and create a branch from `main`
2. Make your changes with tests where applicable
3. Run `swift test` — all tests must pass
4. Open a pull request with a clear description of what changed and why

## Adding activities to the catalog

Edit `Sources/ActivityTaxonomyKit/Resources/activity-catalog.json`. Each entry needs:

| Field | Type | Notes |
|---|---|---|
| `id` | String | Unique, lowercase, no spaces |
| `name` | String | Human-readable display name |
| `variableKey` | String | Stable key used in consuming apps |
| `category` | String | Must match an `ActivityCategory` raw value |
| `iconFilename` | String | SF Symbol name |
| `defaultSortOrder` | Int | Lower = earlier in default sort |

Valid `category` values: `stress`, `foodAndDrink`, `movement`, `bodyAndPhysicalState`, `medical`, `hormonal`, `protectiveAndPositive`

## Code style

- Standard Swift conventions; no third-party linters required
- Prefer `Sendable` conformance on new types
- Keep public API surface minimal — prefer adding to existing types over new ones

## Reporting issues

Please open a GitHub issue with:
- A minimal reproduction case or clear description
- Swift/Xcode version
- Platform (iOS / macOS)
