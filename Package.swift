// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "SwiftCIKernelPlugin",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .plugin(name: "Swift-CIKernel", targets: ["Swift-CIKernel"]),
    ],
    targets: [
        .plugin(name: "Swift-CIKernel", capability: .buildTool()),

        .testTarget(name: "Swift-CIKernel-Tests", exclude: [
            // Exclude so that the default Metal compiler is not used.
            "CIKernels",
        ], plugins: ["Swift-CIKernel"]),
    ]
)
