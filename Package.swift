// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YouboraAVPlayerAdapter",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "YouboraAVPlayerAdapter",
            targets: ["YouboraAVPlayerAdapter"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/markst/lib-plugin-ios.git", branch: "swift-package-xcframework")
    ],
    targets: [
        .target(
            name: "YouboraAVPlayerAdapter",
            dependencies: [
                .product(name: "YouboraLib", package: "lib-plugin-ios")
            ],
            path: "YouboraAVPlayerAdapter/Generic",
            cSettings: [
                .headerSearchPath("adapter")
            ]
        ),
    ]
)
