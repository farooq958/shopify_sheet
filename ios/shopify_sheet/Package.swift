// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "shopify_sheet",
  platforms: [
    .iOS("13.0"),
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
      resources: [
        .process("Resources/PrivacyInfo.xcprivacy"),
      ]
    ),
  ]
)
