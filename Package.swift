// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Diagnostics",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v13),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "Diagnostics",
            targets: ["Diagnostics"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/vmanot/Swallow.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "Diagnostics",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "Swallow"
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "DiagnosticsTests",
            dependencies: ["Diagnostics"],
            path: "Tests"
        )
    ]
)
