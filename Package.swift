// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CombineExt",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Location",
                 targets: ["Location"]),
        .library(
            name: "Publisher+Result",
            targets: ["Publisher+Result"]),
        .library(
            name: "TypeEraseError",
            targets: ["TypeEraseError"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Location"),
        .target(name: "Publisher+Result"),
        .target(name: "TypeEraseError"),

        .testTarget(
            name: "TypeEraseErrorTests",
            dependencies: [
                .target(name: "TypeEraseError")
            ]
        ),
    ]
)