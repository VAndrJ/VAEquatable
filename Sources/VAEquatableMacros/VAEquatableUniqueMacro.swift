//
//  VAEquatableUniqueMacro.swift
//  
//
//  Created by VAndrJ on 09.07.2024.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct VAEquatableUniqueMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        []
    }
}
