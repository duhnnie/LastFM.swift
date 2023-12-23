// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LastFM.swift",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_15),
        .watchOS(.v4),
        .tvOS(.v11),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "LastFM",
            targets: ["LastFM"]),
    ],
    dependencies: [
        .package(
            name: "SwiftRestClient",
            url: "https://github.com/duhnnie/SwiftRestClient",
            from: "0.5.0")
    ],
    targets: [
        .target(
            name: "LastFM",
            dependencies: [
                .product(name: "SwiftRestClient", package: "SwiftRestClient")
            ]),
        .testTarget(
            name: "LastFMTests",
            dependencies: ["LastFM"],
            resources: [
                .copy("Resources")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)

#if os(Linux)
package.dependencies.append(
    .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "3.0.0")
)

package.targets.first?.dependencies += [
    .product(name: "Crypto", package: "swift-crypto")
]
#endif
