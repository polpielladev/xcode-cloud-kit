// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "XcodeCloudKit",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "XcodeCloudKit",
            targets: ["XcodeCloudKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/AvdLee/appstoreconnect-swift-sdk.git", branch: "master")
    ],
    targets: [
        .target(
            name: "XcodeCloudKit",
            dependencies: [.product(name: "AppStoreConnect-Swift-SDK", package: "appstoreconnect-swift-sdk")]
        ),
        .testTarget(
            name: "XcodeCloudKitTests",
            dependencies: ["XcodeCloudKit"]
        ),
    ]
)
