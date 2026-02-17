// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "KeyboardTrackpad",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "KeyboardTrackpad",
            targets: ["KeyboardTrackpad"]
        )
    ],
    targets: [
        .executableTarget(
            name: "KeyboardTrackpad",
            path: "Sources"
        )
    ]
)
