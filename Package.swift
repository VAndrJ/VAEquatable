// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "VAEquatable",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "VAEquatable",
            targets: ["VAEquatable"]
        ),
        .executable(
            name: "VAEquatableClient",
            targets: ["VAEquatableClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .macro(
            name: "VAEquatableMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "VAEquatable", dependencies: ["VAEquatableMacros"]),
        .executableTarget(name: "VAEquatableClient", dependencies: ["VAEquatable"]),
        .testTarget(
            name: "VAEquatableTests",
            dependencies: [
                "VAEquatableMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
