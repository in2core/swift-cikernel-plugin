//
//  xcrun.swift
//  Build-CIKernel
//
//  Created by Michal Tomlein on 06/12/2022.
//

import Foundation

#if !os(macOS)
@objc private protocol NSTask {
    var executableURL: URL? { get set }
    var arguments: [String]? { get set }
    var standardOutput: Any? { get set }
    var terminationStatus: Int32 { get }
    func launch()
    func waitUntilExit()
}
#endif

func xcrun(_ arguments: String...) {
    #if os(macOS)
    let process = Process()
    #else
    let process = unsafeBitCast((NSClassFromString("NSTask") as! NSObject.Type).init(), to: NSTask.self)
    #endif
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
