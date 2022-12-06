//
//  main.swift
//  Build-CIKernel
//
//  Created by Michal Tomlein on 06/12/2022.
//

import Foundation

let args = CommandLine.arguments
guard args.count == 3 else {
    print("Usage: Build-CIKernel input-filter.metal destination-directory")
    exit(1)
}

let inputPath = args[1]
let inputURL = URL(fileURLWithPath: inputPath, isDirectory: false)
let destinationPath = args[2]
let destinationURL = URL(fileURLWithPath: destinationPath, isDirectory: true)

let base = inputURL.deletingPathExtension().lastPathComponent
let cache = "-fmodules-cache-path=\(destinationPath)"

let strings = platforms.map { platform in
    let compiledPath = destinationURL.appendingPathComponent("\(base)-\(platform.identifier).air", isDirectory: false).path
    let linkedURL = destinationURL.appendingPathComponent("\(base)-\(platform.identifier).metallib", isDirectory: false)

    xcrun("-sdk", platform.identifier, "metal", "-fcikernel", inputPath, "-c", "-o", compiledPath, cache, "--target=\(platform.target)")
    xcrun("-sdk", platform.identifier, "metallib", "-cikernel", "-o", linkedURL.path, compiledPath)

    let data: Data
    do {
        data = try Data(contentsOf: linkedURL)
    } catch {
        print(error.localizedDescription)
        exit(2)
    }

    var string = "if \(platform.condition)\nlet \(base)Data = Data([\n"
    for (index, byte) in data.enumerated() {
        let padding = byte < 16 ? "0" : ""
        let newline = (index + 1) % 12 == 0 ? "\n" : ""
        string += " 0x\(padding)\(String(byte, radix: 16)),\(newline)"
    }
    string += string.hasSuffix("\n") ? "])" : "\n])"
    return string
}

let output = Data("""
import Foundation

#\(strings.joined(separator: "\n#else"))
#else
#error("Unsupported platform")
#endif

""".utf8)

let outputURL = destinationURL.appendingPathComponent("\(base)Data.swift", isDirectory: false)

if output == (try? Data(contentsOf: outputURL)) {
    print("Output unchanged")
} else {
    print("Output changed")
    do {
        try output.write(to: outputURL, options: .atomic)
    } catch {
        print(error.localizedDescription)
        exit(3)
    }
}
