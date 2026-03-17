// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Harbor",
    platforms: [
        .iOS(.v17)
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Harbor",
            dependencies: [],
            path: "Harbor"
        )
    ]
)
