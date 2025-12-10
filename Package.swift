// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "EkycSdk",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "EkycSdk",
            targets: ["EkycSdk"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EkycSdk",
            dependencies: [],
            path: "Sources/EkycSdk"
        )
    ]
)
