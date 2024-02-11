// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LevelGeneration",
    products: [
        .library(
            name: "LevelGeneration",
            targets: ["LevelGeneration"]),
    ],
    targets: [
        .target(
            name: "LevelGeneration",
            dependencies: []),
        .testTarget(name: "LevelGenerationTests",
                    dependencies: ["LevelGeneration"]),        
    ]
)
