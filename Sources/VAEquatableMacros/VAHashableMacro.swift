//
//  VAHashableMacro.swift
//  
//
//  Created by VAndrJ on 11.07.2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct VAHashableMacro: ExtensionMacro {

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard declaration is ClassDeclSyntax else {
            throw VAEquatableError.notClass
        }
        guard !declaration.modifiers.isOpen else {
            throw VAEquatableError.openModifier
        }

        let withComputed = node.arguments?.as(LabeledExprListSyntax.self)?.withComputedParam ?? false
        let properties = try declaration.getHashableProperties(withComputed: withComputed, isPublic: declaration.modifiers.isPublic).hashableNames
        let isAlreadyHashable = declaration.inheritanceClause?.inheritedTypes.contains(where: { $0.type.trimmedDescription == .hashable }) ?? false

        return [
            ExtensionDeclSyntax(
                extendedType: type,
                inheritanceClause: isAlreadyHashable ? nil : InheritanceClauseSyntax(
                    inheritedTypes: [InheritedTypeSyntax(type: IdentifierTypeSyntax(name: TokenSyntax.identifier(.hashable)))]
                )
            ) {
                FunctionDeclSyntax(
                    modifiers: DeclModifierListSyntax {
                        declaration.modifiers.accessModifier
                    },
                    name: TokenSyntax.identifier("hash"),
                    signature: FunctionSignatureSyntax(
                        parameterClause: FunctionParameterClauseSyntax(
                            parameters: FunctionParameterListSyntax {
                                FunctionParameterSyntax(
                                    firstName: TokenSyntax.identifier("into"),
                                    secondName: TokenSyntax.identifier("hasher"),
                                    type: AttributedTypeSyntax(
                                        specifier: .keyword(.inout),
                                        baseType: TypeSyntax("Hasher")
                                    )
                                )
                            }
                        )
                    ),
                    bodyBuilder: {
                        CodeBlockItemListSyntax {
                            for property in properties {
                                CodeBlockItemSyntax("hasher.combine(\(raw: property))")
                            }
                        }
                    }
                )
            }
        ]
    }
}
