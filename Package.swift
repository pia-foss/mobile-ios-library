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
        .package(url: "git@github.com:xvpn/kp_releases_apple_kpi.git", .exact("1.1.0")),
        .package(url: "git@github.com:xvpn/kp_releases_apple_csi.git", .exact("1.2.0")),
        .package(url: "git@github.com:xvpn/kp_releases_apple_account.git", .exact("1.3.1")),
        .package(url: "git@github.com:xvpn/kp_releases_apple_regions.git", .exact("1.3.2")),
        .package(url: "git@github.com:xvpn/cpz_pia-mobile_ios_pia-tunnelkit.git", revision: "8b3cdcafd079da39c6cb8dde51efff944e76c055"),
        .package(url: "git@github.com:xvpn/cpz_pia-mobile_ios_pia-wireguard.git", branch: "release/1.2.0"),
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
                .product(name: "PIAKPI", package: "kp_releases_apple_kpi"),
                .product(name: "PIACSI", package: "kp_releases_apple_csi"),
                .product(name: "PIARegions", package: "kp_releases_apple_regions"),
                .product(name: "PIAAccount", package: "kp_releases_apple_account"),
                .product(name: "PIAWireguard", package: "cpz_pia-mobile_ios_pia-wireguard"),
                .product(name: "TunnelKit", package: "cpz_pia-mobile_ios_pia-tunnelkit"),
                .product(name: "TunnelKitOpenVPN", package: "cpz_pia-mobile_ios_pia-tunnelkit"),
                .product(name: "TunnelKitOpenVPNAppExtension", package: "cpz_pia-mobile_ios_pia-tunnelkit"),
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
