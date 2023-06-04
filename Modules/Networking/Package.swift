// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Networking",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [
		.library(
			name: "Networking",
			targets: ["Networking"])
	],
	dependencies: [
		.package(path: "../Common"),
		.package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
		.package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.4.1")
	],
	targets: [
		.target(
			name: "Networking",
			dependencies: [
				.product(name: "Common", package: "Common"),
				.product(name: "Alamofire", package: "Alamofire"),
				.product(name: "Dependencies", package: "swift-dependencies")
			]),
		.testTarget(
			name: "NetworkingTests",
			dependencies: ["Networking"])
	]
)
