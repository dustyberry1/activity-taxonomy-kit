// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ActivityTaxonomyKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
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
            path: "Sources/ActivityTaxonomyKit"
        ),
        .testTarget(
            name: "ActivityTaxonomyKitTests",
            dependencies: ["ActivityTaxonomyKit"],
            path: "Tests/ActivityTaxonomyKitTests"
        ),
    ]
)

