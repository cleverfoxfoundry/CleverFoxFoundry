// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "VikingAlarm",
    platforms: [
        .iOS(.v16)
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
            supportedInterfaceOrientations: [.portrait]
        )
    ],
    targets: [
        .executableTarget(
            name: "VikingAlarm",
            path: "Sources/VikingAlarm"
        )
    ]
)
