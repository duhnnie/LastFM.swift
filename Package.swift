// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftfm",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "swiftfm",
            targets: ["swiftfm"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//        .package(name: "SwiftRestClient", url: "https://github.com/duhnnie/SwiftRestClient", from: "0.1.1")
        .package(name: "SwiftRestClient", path: "/Users/daniel/Projects/SwiftRestClient")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
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
