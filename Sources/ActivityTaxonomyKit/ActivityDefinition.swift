import Foundation

public struct ActivityEntry: Identifiable, Hashable, Sendable, Codable {
    public let id: String
    public let name: String
    public let variableKey: String
    public let category: ActivityCategory
    public let iconFilename: String
    public let defaultSortOrder: Int?

    public init(
        name: String,
        id: String,
        variableKey: String,
        category: ActivityCategory,
        iconFilename: String,
        defaultSortOrder: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.variableKey = variableKey
        self.category = category
        self.iconFilename = iconFilename
        self.defaultSortOrder = defaultSortOrder
    }

    public var isDefaultActive: Bool {
        defaultSortOrder != nil
    }
}
