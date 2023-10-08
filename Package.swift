// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftfm",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .watchOS(.v4),
        .tvOS(.v11),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "swiftfm",
            targets: ["swiftfm"]),
    ],
    dependencies: [
        .package(name: "SwiftRestClient", path: "/Users/daniel/Projects/SwiftRestClient")
    ],
    targets: [
        .target(
            name: "swiftfm",
            dependencies: [
                .product(name: "SwiftRestClient", package: "SwiftRestClient")
            ]),
        .testTarget(
            name: "swiftfmTests",
            dependencies: ["swiftfm"]),
    ]
)
