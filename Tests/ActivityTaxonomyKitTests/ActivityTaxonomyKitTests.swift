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
}

