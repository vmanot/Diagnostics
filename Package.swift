// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Diagnostics",
    platforms: [
        .iOS(.v11),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "Diagnostics",
            targets: ["Diagnostics"]
        )
    ],
    targets: [
        .target(
            name: "Diagnostics",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "DiagnosticsTests",
            dependencies: ["Diagnostics"],
            path: "Tests"
        )
    ]
)
