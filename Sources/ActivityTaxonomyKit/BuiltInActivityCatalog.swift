import Foundation

public struct BuiltInActivityCatalog: Sendable {
    public let all: [ActivityEntry]

    public init(all: [ActivityEntry] = Self.defaultCatalog) {
        self.all = all
    }

    public init(jsonData: Data) throws {
        let decoder = JSONDecoder()
        let document = try decoder.decode(ActivityCatalogDocument.self, from: jsonData)
        self.all = document.activities
    }

    public init(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        try self.init(jsonData: data)
    }

    public static let defaultCatalogResourceName = "activity-catalog"
    public static let shared = BuiltInActivityCatalog(all: loadDefaultCatalog())

    public static func builtIn() -> BuiltInActivityCatalog {
        .shared
    }

    public static func load(resourceName: String, in bundle: Bundle? = nil) throws -> BuiltInActivityCatalog {
        let sourceBundle = bundle ?? Bundle.module
        guard let catalogURL = sourceBundle.url(forResource: resourceName, withExtension: "json") else {
            throw Error.missingResource(resourceName)
        }
        return try load(contentsOf: catalogURL)
    }

    public static func load(contentsOf url: URL) throws -> BuiltInActivityCatalog {
        try BuiltInActivityCatalog(contentsOf: url)
    }

    public static let defaultCatalog: [ActivityEntry] = [
        ActivityEntry(name: "Stress", id: "high_stress", variableKey: "stress", category: .stressAndMentalState, iconFilename: "brain", defaultSortOrder: 1),
        ActivityEntry(name: "Anxiety", id: "anxiety", variableKey: "anxiety", category: .stressAndMentalState, iconFilename: "brain", defaultSortOrder: nil),
        ActivityEntry(name: "Caffeine", id: "caffeine", variableKey: "caffeine", category: .foodAndDrink, iconFilename: "coffee", defaultSortOrder: 2),
        ActivityEntry(name: "Sitting", id: "prolonged_sitting", variableKey: "prolonged_sitting", category: .movementAndActivity, iconFilename: "chair", defaultSortOrder: 3),
        ActivityEntry(name: "Alcohol", id: "alcohol", variableKey: "alcohol", category: .foodAndDrink, iconFilename: "wine", defaultSortOrder: 4),
        ActivityEntry(name: "Intimacy", id: "sexual_activity", variableKey: "sexual_activity", category: .bodyAndPhysicalState, iconFilename: "heart", defaultSortOrder: 5),
        ActivityEntry(name: "Exercise", id: "exercise", variableKey: "exercise", category: .movementAndActivity, iconFilename: "barbell", defaultSortOrder: 6),
        ActivityEntry(name: "PT Session", id: "pt_session", variableKey: "pt_session", category: .medicalAndTherapeutic, iconFilename: "first-aid-kit", defaultSortOrder: nil),
        ActivityEntry(name: "Spicy Food", id: "spicy_food", variableKey: "spicy_food", category: .foodAndDrink, iconFilename: "pepper", defaultSortOrder: nil),
        ActivityEntry(name: "Acidic Food", id: "acidic_food", variableKey: "acidic_food", category: .foodAndDrink, iconFilename: "orange-slice", defaultSortOrder: nil),
        ActivityEntry(name: "Carbonation", id: "carbonated_drinks", variableKey: "carbonated_drinks", category: .foodAndDrink, iconFilename: "champagne", defaultSortOrder: nil),
        ActivityEntry(name: "Sweeteners", id: "artificial_sweeteners", variableKey: "artificial_sweeteners", category: .foodAndDrink, iconFilename: "cube", defaultSortOrder: nil),
        ActivityEntry(name: "Chocolate", id: "chocolate", variableKey: "chocolate", category: .foodAndDrink, iconFilename: "cookie", defaultSortOrder: nil),
        ActivityEntry(name: "Dairy", id: "dairy", variableKey: "dairy", category: .foodAndDrink, iconFilename: "cow", defaultSortOrder: nil),
        ActivityEntry(name: "Cranberry", id: "cranberry", variableKey: "cranberry", category: .foodAndDrink, iconFilename: "cherries", defaultSortOrder: nil),
        ActivityEntry(name: "Dehydration", id: "dehydration", variableKey: "dehydration", category: .foodAndDrink, iconFilename: "drop-slash", defaultSortOrder: nil),
        ActivityEntry(name: "Cycling", id: "cycling", variableKey: "cycling", category: .movementAndActivity, iconFilename: "bicycle", defaultSortOrder: nil),
        ActivityEntry(name: "Travel", id: "travel", variableKey: "travel", category: .movementAndActivity, iconFilename: "airplane-tilt", defaultSortOrder: nil),
        ActivityEntry(name: "Driving", id: "long_drive", variableKey: "long_drive", category: .movementAndActivity, iconFilename: "car-profile", defaultSortOrder: nil),
        ActivityEntry(name: "Poor Sleep", id: "poor_sleep", variableKey: "poor_sleep", category: .stressAndMentalState, iconFilename: "bed", defaultSortOrder: nil),
        ActivityEntry(name: "Work", id: "long_work_day", variableKey: "long_work_day", category: .stressAndMentalState, iconFilename: "briefcase", defaultSortOrder: nil),
        ActivityEntry(name: "Illness", id: "illness", variableKey: "illness", category: .bodyAndPhysicalState, iconFilename: "thermometer", defaultSortOrder: nil),
        ActivityEntry(name: "Constipation", id: "constipation", variableKey: "constipation", category: .bodyAndPhysicalState, iconFilename: "toilet", defaultSortOrder: nil),
        ActivityEntry(name: "Smoking", id: "smoking", variableKey: "smoking", category: .bodyAndPhysicalState, iconFilename: "cigarette", defaultSortOrder: nil),
        ActivityEntry(name: "Cycle", id: "menstruation", variableKey: "menstruation", category: .hormonalAndReproductive, iconFilename: "drop", defaultSortOrder: nil),
        ActivityEntry(name: "PMS", id: "pms", variableKey: "pms", category: .hormonalAndReproductive, iconFilename: "calendar-heart", defaultSortOrder: nil),
        ActivityEntry(name: "Med Change", id: "medication_change", variableKey: "medication_change", category: .medicalAndTherapeutic, iconFilename: "pill", defaultSortOrder: nil),
        ActivityEntry(name: "New Supplement", id: "new_supplement", variableKey: "new_supplement", category: .medicalAndTherapeutic, iconFilename: "prescription", defaultSortOrder: nil),
        ActivityEntry(name: "Mindfulness", id: "mindfulness", variableKey: "mindfulness", category: .protectiveAndPositive, iconFilename: "flower-lotus", defaultSortOrder: nil),
        ActivityEntry(name: "Rest Day", id: "rest_day", variableKey: "rest_day", category: .protectiveAndPositive, iconFilename: "couch", defaultSortOrder: nil),
        ActivityEntry(name: "Self Care", id: "relaxation", variableKey: "relaxation", category: .protectiveAndPositive, iconFilename: "tea-bag", defaultSortOrder: nil)
    ]

    public static func loadDefault() throws -> BuiltInActivityCatalog {
        try load(resourceName: defaultCatalogResourceName)
    }

    public func activity(for variableKey: String) -> ActivityEntry? {
        all.first { $0.variableKey == variableKey }
    }

    public func activity(by id: String) -> ActivityEntry? {
        all.first { $0.id == id }
    }

    public func allActivities() -> [ActivityEntry] {
        all
    }

    public func uniqueIconFilenames() -> [String] {
        Array(Set(all.map(\.iconFilename))).sorted()
    }

    public func activities(in category: ActivityCategory) -> [ActivityEntry] {
        all.filter { $0.category == category }
    }

    public func displayName(for variableKey: String) -> String? {
        activity(for: variableKey)?.name
    }

    public func insightDisplayName(for variableKey: String, preferredName: String? = nil) -> String? {
        let trimmedPreferredName = preferredName?.trimmingCharacters(in: .whitespacesAndNewlines)

        if variableKey == "stress" {
            if let preferred = trimmedPreferredName, !preferred.isEmpty, preferred != displayName(for: "stress") {
                return preferred
            }
            return "Stress / Anxiety"
        }

        if let preferred = trimmedPreferredName, !preferred.isEmpty {
            return preferred
        }

        return displayName(for: variableKey)
    }

    public func iconName(for variableKey: String) -> String? {
        activity(for: variableKey)?.iconFilename
    }

    public func search(query: String) -> [ActivityEntry] {
        let tokens = normalize(query)
        guard !tokens.isEmpty else { return all }
        return all
            .filter { normalize($0.name).contains(tokens) }
            .sorted { lhs, rhs in
                let lhsName = normalize(lhs.name)
                let rhsName = normalize(rhs.name)
                if lhsName == tokens && rhsName != tokens {
                    return true
                }
                if rhsName == tokens && lhsName != tokens {
                    return false
                }
                if lhs.defaultSortOrder != rhs.defaultSortOrder,
                   let lhsSort = lhs.defaultSortOrder,
                   let rhsSort = rhs.defaultSortOrder {
                    return lhsSort < rhsSort
                }
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    private func normalize(_ value: String) -> String {
        value
            .lowercased()
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    private static func loadDefaultCatalog() -> [ActivityEntry] {
        do {
            return try loadDefault().all
        } catch {
            return defaultCatalog
        }
    }
}

private extension BuiltInActivityCatalog {
    struct ActivityCatalogDocument: Decodable {
        let schema: String?
        let version: String?
        let activities: [ActivityEntry]
    }
}

public extension BuiltInActivityCatalog {
    enum Error: Swift.Error, Sendable {
        case missingResource(String)
    }
}
