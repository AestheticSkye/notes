// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "notes",
        platforms: [.macOS(.v12)],
        products: [
            // Products define the executables and libraries a package produces, and make them visible to other packages.
            .executable(name: "notes",
                    targets: ["notes"]),
        ],
        dependencies: [
            // Dependencies declare other packages that this package depends on.
            // .package(url: /* package url */, from: "1.0.0"),
            .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
            .package(url: "https://github.com/rderik/SwiftCursesTerm.git", from: "0.1.2"),
        ],
        targets: [
            // Targets are the basic building blocks of a package. A target can define a module or a test suite.
            // Targets can depend on other targets in this package, and on products in packages this package depends on.
            .executableTarget(
                    name: "notes",
                    dependencies: [
                        .product(name: "ArgumentParser", package: "swift-argument-parser"),
                        .product(name: "SwiftCursesTerm", package: "SwiftCursesTerm"),
						.byName(name: "CWrapper")
                    ],
                    path: "Sources/Notes"),
			.systemLibrary(name: "CWrapper"),
            .testTarget(
                    name: "NotesTests",
                    dependencies: ["notes"]),
        ]
)
