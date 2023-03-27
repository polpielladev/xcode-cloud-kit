// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "XcodeCloudKit",
    products: [
        .library(
            name: "XcodeCloudKit",
            targets: ["XcodeCloudKit"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "XcodeCloudKit",
            dependencies: []
        ),
        .testTarget(
            name: "XcodeCloudKitTests",
            dependencies: ["XcodeCloudKit"]
        ),
    ]
)
