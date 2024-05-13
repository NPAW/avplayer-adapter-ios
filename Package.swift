// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YouboraAVPlayerAdapter",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "YouboraAVPlayerAdapter",
            targets: ["YouboraAVPlayerAdapter"]),
    ],
    dependencies: [
        .package(url: "https://bitbucket.org/npaw/lib-plugin-spm-ios.git", .upToNextMajor(from: "6.7.10"))
    ],
    targets: [
        .target(name: "YouboraAVPlayerAdapter",
                dependencies: [
                    .product(name: "YouboraLib", package: "lib-plugin-spm-ios")
                ],
                exclude: [
                    "Info.plist"
                ]
        ),
    ]
)
