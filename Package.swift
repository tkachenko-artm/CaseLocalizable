// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "CaseLocalizable",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(
            name: "CaseLocalizable",
            targets: ["CaseLocalizable"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0-latest")
    ],
    targets: [
        .macro(
            name: "CaseLocalizableMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "CaseLocalizable",
            dependencies: ["CaseLocalizableMacros"]
        ),
        .testTarget(
            name: "CaseLocalizableTests",
            dependencies: [
                "CaseLocalizable",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
