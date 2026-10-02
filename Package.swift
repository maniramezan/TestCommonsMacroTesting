// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "TestCommonsMacroTesting",
    platforms: [.macOS(.v13), .iOS(.v17)],
    products: [.library(name: "TestCommonsMacroTesting", targets: ["TestCommonsMacroTesting"])],
    dependencies: [.package(url: "https://github.com/swiftlang/swift-syntax.git", "600.0.0"..<"700.0.0")],
    targets: [
        .target(
            name: "TestCommonsMacroTesting",
            dependencies: [
                .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax")
            ]),
        .testTarget(name: "TestCommonsMacroTestingTests", dependencies: ["TestCommonsMacroTesting"]),
    ],
    swiftLanguageModes: [.v6]
)
