// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "fourteenth-clue",
	dependencies: [
		.package(url: "https://github.com/autoreleasefool/fourteenth-clue-kit", branch: "main"),
		.package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.executableTarget(
			name: "fourteenth-clue",
			dependencies: [
				.product(name: "FourteenthClueKit", package: "fourteenth-clue-kit"),
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
			]
		),
		.testTarget(
			name: "FourteenthClueTests",
			dependencies: ["fourteenth-clue"],
			path: "Tests/FourteenthClueTests"
		),
	]
)
