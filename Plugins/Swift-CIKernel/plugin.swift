//
//  plugin.swift
//  Swift-CIKernel
//
//  Created by Michal Tomlein on 13/06/2022.
//

import Foundation
import PackagePlugin

@main
struct BuildCIKernel: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let target = target as? SourceModuleTarget else { return [] }

        let executable = try context.tool(named: "Build-CIKernel").path

        return try FileManager.default.subpathsOfDirectory(atPath: target.directory.string).filter {
            $0.hasSuffix("Filter.metal")
        }.map { source in
            let source = target.directory.appending(source)
            let output = context.pluginWorkDirectory.appending("\(source.stem)Data.swift")

            return .buildCommand(displayName: "Build CI Kernel", executable: executable, arguments: [
                source.string,
                context.pluginWorkDirectory.string
            ], environment: [:], inputFiles: [
                source
            ], outputFiles: [
                output
            ])
        }
    }
}
