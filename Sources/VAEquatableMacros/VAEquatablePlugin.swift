//
//  VAEquatablePlugin.swift
//  
//
//  Created by VAndrJ on 06.07.2024.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct VAEquatablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        VAEquatableMacro.self,
        VAEquatableIgnoredMacro.self,
        VAEquatableUniqueMacro.self,
    ]
}
