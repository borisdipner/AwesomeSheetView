// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "AwesomeSheetView",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AwesomeSheetView",
            targets: ["AwesomeSheetView"]),
    ],
    targets: [
        .target(
            name: "AwesomeSheetView"),
        .testTarget(
            name: "AwesomeSheetViewTests",
            dependencies: ["AwesomeSheetView"]),
    ]
)
