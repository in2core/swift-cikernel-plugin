# Swift CIKernel Plugin

The Swift CIKernel Plugin is a Swift Package Manager build tool plugin that builds Core Image Kernels into platform-specific `Foundation.Data` constants.

Unlike regular Metal sources, Core Image Kernels are built by passing the `-fcikernel` and `-cikernel` arguments to the Metal compiler and linker, respectively.
This makes them a challenge to use in Swift Packages.

This plugin compiles Metal sources in your package target that follow the `*Filter.metal` naming convention into separate Metal libraries that then become available as constants of type `Foundation.Data` within your target.

For example, if your target includes a file named [`FalseColorFilter.metal`](Tests/Swift-CIKernel-Tests/FalseColorFilter.swift), this will produce a constant named `FalseColorFilterData` that you can [use from Swift](Tests/Swift-CIKernel-Tests/FalseColorFilter.swift#L30) as follows:

```swift
try CIKernel(functionName: "cdl", fromMetalLibraryData: FalseColorFilterData)
```

The filter is compiled separately for macOS (10.15+), iOS and tvOS (13+).
`FalseColorFilterData` is conditionally defined for each of these platforms.

## Usage

To use the Swift CIKernel Plugin with your package, first add it as a dependency:

```swift
// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "ExamplePackage",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "ExampleLibrary", targets: ["ExampleTarget"]),
    ],
    dependencies: [
        .package(url: "https://github.com/in2core/swift-cikernel-plugin.git", branch: "main"),
    ],
    targets: [
        .target(name: "ExampleTarget",
                // Exclude so that the default Metal compiler is not used.
                exclude: ["CIKernels"],
                plugins: [
                    .plugin(name: "Swift-CIKernel", package: "Swift-CIKernel-Plugin"),
                ]),
    ]
)
```

Notice that we exclude a folder named `CIKernels` from the target to prevent the default Metal compiler from being used.
In this example, we would place our Core Image Kernels into the `Sources/ExampleTarget/CIKernels` directory.
Alternatively, we could list the kernel source files one by one.

The test target in this package itself serves as an example of how this plugin is intended to be used.
