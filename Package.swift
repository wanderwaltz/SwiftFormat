// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftFormat",
    products: [
      .library(name: "SwiftFormat", targets: ["SwiftFormat"])
    ],
    targets: [
        .target(
            name: "SwiftFormat",
            path: "Sources"
        )
    ]
)
