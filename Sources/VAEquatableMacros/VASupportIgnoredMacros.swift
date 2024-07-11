//
//  VASupportIgnoredMacros.swift
//
//
//  Created by VAndrJ on 06.07.2024.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct VAEquatableIgnoredMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        []
    }
}

public struct VAHashableIgnoredMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        []
    }
}
