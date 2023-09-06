// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PIALibrary",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "PIALibrary", 
            targets: [
                "PIALibrary",
                "PIALibraryUtilObjC",
            ]
        ),
    ],
    dependencies: [
        .package(url: "git@github.com:pia-foss/releases-apple-kpi.git", .exact("1.1.0")),
        .package(url: "git@github.com:pia-foss/releases-apple-csi.git", .exact("1.2.0")),
        .package(url: "git@github.com:pia-foss/releases-apple-account.git", .exact("1.3.1")),
        .package(url: "git@github.com:pia-foss/releases-apple-regions.git", .exact("1.3.2")),
        .package(url: "git@github.com:pia-foss/tunnelkit.git", branch: "master"),
        .package(url: "git@github.com:pia-foss/ios-wireguard.git", branch: "master"),
        .package(url: "https://github.com/hkellaway/Gloss.git", from: "3.1.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "3.4.1"),
        .package(url: "https://github.com/huri000/SwiftEntryKit.git", from: "1.0.3"),
        .package(url: "https://github.com/Orderella/PopupDialog.git", branch: "master"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.0"),
        .package(url: "https://github.com/ashleymills/Reachability.swift.git", from: "4.3.0"),
        .package(url: "https://github.com/michaeltyson/TPKeyboardAvoiding.git", from: "1.3.5"),
    ],
    targets: [
        .target(
            name: "PIALibrary", 
            dependencies: [
                "SwiftyBeaver",
                "Gloss",
                "PIALibraryUtilObjC",
                "SwiftEntryKit",
                "PopupDialog",
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "Reachability", package: "Reachability.swift"),
                .product(name: "PIAKPI", package: "releases-apple-kpi"),
                .product(name: "PIACSI", package: "releases-apple-csi"),
                .product(name: "PIARegions", package: "releases-apple-regions"),
                .product(name: "PIAAccount", package: "releases-apple-account"),
                .product(name: "PIAWireguard", package: "ios-wireguard"),
                .product(name: "TunnelKit", package: "tunnelkit"),
                .product(name: "TunnelKitOpenVPN", package: "tunnelkit"),
                .product(name: "TunnelKitOpenVPNAppExtension", package: "tunnelkit"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "PIALibraryUtilObjC", 
            dependencies: []
        ),
        .testTarget(
            name: "PIALibraryTests",
            dependencies: [
                "PIALibrary",
            ],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
