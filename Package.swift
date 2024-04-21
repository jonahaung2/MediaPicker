// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MediaPicker",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17)],
    products: [
        .library(
            name: "MediaPicker",
            targets: ["MediaPicker"]),
    ],
    targets: [
        .target(
            name: "MediaPicker"),
        .testTarget(
            name: "MediaPickerTests",
            dependencies: ["MediaPicker"]),
    ]
)
