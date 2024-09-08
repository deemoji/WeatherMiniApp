// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherMiniApp",
    platforms: [.iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WeatherMiniApp",
            targets: ["WeatherMiniApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WeatherMiniApp",
            dependencies: [
                "Alamofire",
                "Kingfisher"
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "WeatherMiniAppTests",
            dependencies: ["WeatherMiniApp"]),
    ]
)
