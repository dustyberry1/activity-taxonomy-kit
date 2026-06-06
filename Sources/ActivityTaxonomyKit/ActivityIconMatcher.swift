import Foundation

public protocol ActivityIconMatcherProtocol: Sendable {
    func suggestIcon(for name: String) -> String?
    func search(query: String) -> [String]
    func allIcons() -> [String]
}

public struct ActivityIconMatcher: ActivityIconMatcherProtocol {
    private let defaultIcon: String
    private let icons: [String]

    public init(iconNames: [String], defaultIcon: String = "sparkle") {
        let normalized = Array(Set(iconNames.compactMap { name in
            let cleaned = name
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            return cleaned.isEmpty ? nil : cleaned
        }))
        self.icons = normalized
            .filter { !$0.isEmpty }
            .sorted()
        self.defaultIcon = defaultIcon
    }

    public init(defaultIcon: String = "sparkle") {
        self.init(iconNames: [], defaultIcon: defaultIcon)
    }

    public func suggestIcon(for name: String) -> String? {
        let tokens = Set(tokenize(name))
        guard !tokens.isEmpty else { return defaultIcon }

        let ranked = icons
            .map { icon in
                let iconTokens = Set(tokenize(icon))
                return (icon: icon, score: tokens.intersection(iconTokens).count)
            }
            .sorted { lhs, rhs in
                if lhs.score != rhs.score {
                    return lhs.score > rhs.score
                }
                return lhs.icon < rhs.icon
            }

        return ranked.first(where: { $0.score > 0 })?.icon ?? defaultIcon
    }

    public func search(query: String) -> [String] {
        let normalizedQuery = normalize(query)
        guard !normalizedQuery.isEmpty else { return icons }

        return icons
            .filter { normalize($0).contains(normalizedQuery) }
            .sorted { lhs, rhs in
                let lhsStarts = normalize(lhs).hasPrefix(normalizedQuery)
                let rhsStarts = normalize(rhs).hasPrefix(normalizedQuery)
                if lhsStarts != rhsStarts { return lhsStarts }
                return lhs < rhs
            }
    }

    public func allIcons() -> [String] {
        icons
    }

    private func tokenize(_ value: String) -> [String] {
        normalize(value)
            .split(separator: " ")
            .map(String.init)
            .filter { !$0.isEmpty }
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
}
