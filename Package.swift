// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ActivityTaxonomyKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "ActivityTaxonomyKit",
            targets: ["ActivityTaxonomyKit"]
        ),
    ],
    targets: [
        .target(
            name: "ActivityTaxonomyKit",
            path: "Sources/ActivityTaxonomyKit",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ActivityTaxonomyKitTests",
            dependencies: ["ActivityTaxonomyKit"],
            path: "Tests/ActivityTaxonomyKitTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
