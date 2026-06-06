import XCTest
@testable import ActivityTaxonomyKit

final class ActivityTaxonomyKitTests: XCTestCase {
    func testCatalogDisplaysKnownActivity() {
        let catalog = BuiltInActivityCatalog.builtIn()

        let stressDisplayName = catalog.displayName(for: "stress")
        let stressIcon = catalog.iconName(for: "stress")

        XCTAssertEqual(stressDisplayName, "Stress")
        XCTAssertEqual(stressIcon, "brain")
    }

    func testInsightDisplayNameReturnsCustomWhenProvided() {
        let catalog = BuiltInActivityCatalog.builtIn()

        XCTAssertEqual(
            catalog.insightDisplayName(for: "stress", preferredName: "System Stress"),
            "System Stress"
        )
    }

    func testCatalogSearchOrdersByPrefixAndDefaults() {
        let catalog = BuiltInActivityCatalog.builtIn()
        let matches = catalog.search(query: "sp")

        XCTAssertFalse(matches.isEmpty)
        XCTAssertEqual(matches.first?.variableKey, "spicy_food")
    }

    func testIconMatcherSuggestsFallback() {
        let matcher = ActivityIconMatcher(iconNames: ["coffee", "wine", "brain", "bed", "sparkle"])

        let result = matcher.suggestIcon(for: "")
        XCTAssertEqual(result, "sparkle")
    }

    func testIconMatcherSearchRespectsNormalizedCase() {
        let matcher = ActivityIconMatcher(iconNames: ["Coffee", "Wine", "sleeping-cat"])

        let result = matcher.search(query: "WINE")
        XCTAssertEqual(result, ["wine"])
    }

    func testBuiltInCatalogLoadsFromBundledJSON() throws {
        let catalog = try BuiltInActivityCatalog.load(resourceName: "activity-catalog", in: Bundle.module)

        XCTAssertGreaterThan(catalog.all.count, 0)
        XCTAssertEqual(catalog.activity(for: "stress")?.id, "high_stress")
        XCTAssertEqual(catalog.activity(for: "stress")?.category, .stressAndMentalState)
    }

    func testCatalogCanLoadFromCustomJSON() throws {
        let payload = """
{
  "schema": "activity-taxonomy-catalog-v1",
  "version": "1.0",
  "activities": [
    {
      "id": "hydration",
      "name": "Hydration",
      "variableKey": "hydration",
      "category": "bodyAndPhysicalState",
      "iconFilename": "drop"
    }
  ]
}
"""
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("activity-taxonomy-catalog-test.json")
        try payload.data(using: .utf8)!.write(to: tempURL)
        defer { try? FileManager.default.removeItem(at: tempURL) }

        let catalog = try BuiltInActivityCatalog.load(contentsOf: tempURL)
        XCTAssertEqual(catalog.all.count, 1)
        XCTAssertEqual(catalog.activity(for: "hydration")?.name, "Hydration")
    }

    func testLoadingMissingCatalogResourceThrows() {
        XCTAssertThrowsError(try BuiltInActivityCatalog.load(resourceName: "missing-activity-catalog", in: Bundle.module))
    }
}
