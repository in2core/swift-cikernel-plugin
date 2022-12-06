//
//  xcrun.swift
//  Build-CIKernel
//
//  Created by Michal Tomlein on 06/12/2022.
//

import Foundation

func xcrun(_ arguments: String...) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun", isDirectory: false)
    process.arguments = arguments
    let output = Pipe()
    process.standardOutput = output
    process.launch()
    let data = output.fileHandleForReading.readDataToEndOfFile()
    process.waitUntilExit()
    if let string = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines), !string.isEmpty {
        print(string)
    }
    guard process.terminationStatus == 0 else {
        exit(process.terminationStatus)
    }
}
