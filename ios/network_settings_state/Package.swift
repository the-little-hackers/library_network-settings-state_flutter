// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "network_settings_state",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "network-settings-state", targets: ["network_settings_state"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "network_settings_state",
            dependencies: [],
            resources: []
        )
    ]
)
