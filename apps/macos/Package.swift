// swift-tools-version: 6.2
// Package manifest for the Aren macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "Aren",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "ArenIPC", targets: ["ArenIPC"]),
        .library(name: "ArenDiscovery", targets: ["ArenDiscovery"]),
        .executable(name: "Aren", targets: ["Aren"]),
        .executable(name: "aren-mac", targets: ["ArenMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/ArenKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "ArenIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "ArenDiscovery",
            dependencies: [
                .product(name: "ArenKit", package: "ArenKit"),
            ],
            path: "Sources/ArenDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "Aren",
            dependencies: [
                "ArenIPC",
                "ArenDiscovery",
                .product(name: "ArenKit", package: "ArenKit"),
                .product(name: "ArenChatUI", package: "ArenKit"),
                .product(name: "ArenProtocol", package: "ArenKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/Aren.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "ArenMacCLI",
            dependencies: [
                "ArenDiscovery",
                .product(name: "ArenKit", package: "ArenKit"),
                .product(name: "ArenProtocol", package: "ArenKit"),
            ],
            path: "Sources/ArenMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "ArenIPCTests",
            dependencies: [
                "ArenIPC",
                "Aren",
                "ArenDiscovery",
                .product(name: "ArenProtocol", package: "ArenKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
