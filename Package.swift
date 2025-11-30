// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LiveImage",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LiveImage",
            targets: ["LiveImage"]
        ),
        .executable(
            name: "Demo",
            targets: ["Demo"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LiveImage"),
        .testTarget(
            name: "LiveImageTests",
            dependencies: ["LiveImage"]
        ),
        .executableTarget(
            name: "Demo",
            dependencies: ["LiveImage"],
            path: "Sources/Demo",
            resources: [
                .copy("Resources/Images") ,
            ]
        ),
    ],
    // Swift Package Index metadata
    metadata: {
        .website(URL(string: "https://github.com/wflixu/LiveImage")!)
        .description("A high-performance SwiftUI animated image library supporting GIF, APNG and WebP formats")
        .keywords(["SwiftUI", "Animation", "GIF", "APNG", "WebP", "Image", "macOS", "iOS"])
        .license(.mit(URL(string: "https://github.com/wflixu/LiveImage/blob/main/LICENSE")!))
        .version("1.0.0")
    }
)
