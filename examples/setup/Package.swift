// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Speculid-Sample-Setup",
    platforms: [.macOS(.v10_11)],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/weichsel/ZIPFoundation/", .upToNextMajor(from: "0.9.0")),
        .package(url: "https://github.com/mxcl/PromiseKit.git", .upToNextMajor(from: "6.8.4")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Speculid-Sample-Setup",
            dependencies: ["ZIPFoundation", "PromiseKit"]),
        .testTarget(
            name: "Speculid-Sample-SetupTests",
            dependencies: ["Speculid-Sample-Setup"]),
    ]
)
