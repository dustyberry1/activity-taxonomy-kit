#if canImport(SwiftUI)
import SwiftUI

/// A small demo for searching activities and browsing matching SF Symbols.
public struct ActivityIconDemoView: View {
    let catalog: BuiltInActivityCatalog
    @State private var query = ""

    public init(catalog: BuiltInActivityCatalog = .builtIn()) {
        self.catalog = catalog
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Activity Search") {
                    TextField("Search activities or symbols...", text: $query)
                        .textFieldStyle(.roundedBorder)

                    ForEach(catalog.search(query: query), id: \.id) { entry in
                        HStack(spacing: 12) {
                            Image(systemName: entry.iconFilename)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.blue, .yellow)
                                .font(.title3)
                                .frame(width: 32)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.name)
                                Text(entry.category.rawValue)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Icon Search") {
                    let sortedIcons = catalog.uniqueIconFilenames()
                    let matches = query.isEmpty ? sortedIcons : sortedIcons.filter {
                        $0.localizedCaseInsensitiveContains(query)
                    }

                    ForEach(matches, id: \.self) { icon in
                        HStack(spacing: 12) {
                            Image(systemName: icon)
                                .font(.title3)
                                .frame(width: 32)
                            Text(icon)
                                .font(.callout)
                        }
                    }
                }
            }
            .navigationTitle("ActivityTaxonomyKit Demo")
        }
    }
}
#endif
