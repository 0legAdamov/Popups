// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Popups",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Popups", targets: ["Popups"]),
        //.product(name: "RxCocoa", package: "RxSwift"),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.0.0-rc.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "Popups", dependencies: ["RxSwift", .product(name: "RxCocoa", package: "RxSwift")], path: "Sources"),
        .testTarget(name: "PopupsTests", dependencies: ["Popups"]),
    ],
    swiftLanguageVersions: [.v5]
)
