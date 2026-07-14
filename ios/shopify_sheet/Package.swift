// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "shopify_sheet",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "shopify-sheet", targets: ["shopify_sheet"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Shopify/checkout-sheet-kit-swift", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "shopify_sheet",
            dependencies: [
                .product(name: "ShopifyCheckoutSheetKit", package: "checkout-sheet-kit-swift"),
            ],
            path: "Sources/shopify_sheet",
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)
