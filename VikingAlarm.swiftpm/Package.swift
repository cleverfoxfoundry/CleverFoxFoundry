// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VikingAlarm",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .iOSApplication(
            name: "VikingAlarm",
            targets: ["VikingAlarm"],
            bundleIdentifier: "com.cleverfoxfoundry.vikingalarm",
            teamIdentifier: "",
            displayVersion: "1.0.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .clock),
            accentColor: .presetColor(.orange),
            supportedDeviceFamilies: [.phone, .pad],
            supportedInterfaceOrientations: [.portrait],
            appCategory: .utilities
        )
    ],
    targets: [
        .executableTarget(
            name: "VikingAlarm",
            path: "Sources/VikingAlarm"
        )
    ]
)
