//
//  platforms.swift
//  Build-CIKernel
//
//  Created by Michal Tomlein on 06/12/2022.
//

import Foundation

let platforms = [
    (identifier: "macosx", target: "air64-apple-macosx10.15.0", condition: "os(macOS) || targetEnvironment(macCatalyst)"),
    (identifier: "iphoneos", target: "air64-apple-ios13.0", condition: "os(iOS)"),
    (identifier: "appletvos", target: "air64-apple-tvos13.0", condition: "os(tvOS)"),
]
