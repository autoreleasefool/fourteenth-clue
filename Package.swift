// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "fourteenth-clue",
	platforms: [
		.macOS(.v10_15),
	],
	dependencies: [
		.package(url: "https://github.com/autoreleasefool/fourteenth-clue-kit", branch: "main"),
		.package(url: "https://github.com/vapor/console-kit", from: "4.2.7"),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.executableTarget(
			name: "fourteenth-clue",
			dependencies: [
				.product(name: "FourteenthClueKit", package: "fourteenth-clue-kit"),
				.product(name: "ConsoleKit", package: "console-kit"),
			]
		),
		.testTarget(
			name: "FourteenthClueTests",
			dependencies: ["fourteenth-clue"],
			path: "Tests/FourteenthClueTests"
		),
	]
)
