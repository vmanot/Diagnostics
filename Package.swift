// swift-tools-version:5.5

import PackageDescription

var package = Package(
    name: "Diagnostics",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Diagnostics",
            targets: ["Diagnostics"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/vmanot/Swallow.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "Diagnostics",
            dependencies: [
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

// TODO: Improve conditionalization.
#if os(Linux)
package.dependencies.append(.package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"))
package.targets = package.targets.map { target in
    var target = target
    target.dependencies.append(.product(name: "Logging", package: "swift-log"))
    return target
}
#endif
