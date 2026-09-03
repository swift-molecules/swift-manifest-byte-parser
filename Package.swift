// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-manifest-byte-parser",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Manifest Byte Parser",
            targets: ["Manifest Byte Parser"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-cursor.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-manifest.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ascii.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-iterator-parser.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Manifest Byte Parser",
            dependencies: [
                .product(name: "Manifest", package: "swift-manifest"),
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
                .product(name: "Cursor", package: "swift-cursor"),
                .product(name: "Cursor Standard Library Integration", package: "swift-cursor"),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
                .product(name: "Iterator Parser", package: "swift-iterator-parser"),
            ]
        ),
        .testTarget(
            name: "Manifest Byte Parser Tests",
            dependencies: [
                .product(name: "Manifest", package: "swift-manifest"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
