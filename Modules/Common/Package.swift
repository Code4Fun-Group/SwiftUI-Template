// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Common",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [
		.library(
			name: "Common",
			targets: ["Common"])
	],
	dependencies: [
		.package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", branch: "master")
	],
	targets: [
		.target(
			name: "Common",
			dependencies: [
				.product(name: "KeychainAccess", package: "KeychainAccess")
			]),
		.testTarget(
			name: "CommonTests",
			dependencies: ["Common"])
	]
)
