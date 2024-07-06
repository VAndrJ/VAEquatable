import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct VAEquatableMacro: ExtensionMacro {

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
        let storedProperties = try declaration.getProperties(withComputed: withComputed, isPublic: declaration.modifiers.isPublic)
        let properties = storedProperties.compactMap(\.name)
        let isAlreadyEquatable = declaration.inheritanceClause?.inheritedTypes.contains(where: { $0.trimmedDescription == "Equatable" }) ?? false

        return [
            ExtensionDeclSyntax(
                extendedType: type,
                inheritanceClause: isAlreadyEquatable ? nil : InheritanceClauseSyntax(
                    inheritedTypes: [InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "Equatable"))]
                )
            ) {
                FunctionDeclSyntax(
                    modifiers: DeclModifierListSyntax {
                        declaration.modifiers.accessModifier
                        DeclModifierSyntax(name: .keyword(.static))
                    },
                    name: TokenSyntax.identifier("=="),
                    signature: FunctionSignatureSyntax(
                        parameterClause: FunctionParameterClauseSyntax(
                            parameters: FunctionParameterListSyntax {
                                FunctionParameterSyntax(firstName: TokenSyntax.identifier("lhs"), type: type)
                                FunctionParameterSyntax(firstName: TokenSyntax.identifier("rhs"), type: type)
                            }
                        ),
                        returnClause: ReturnClauseSyntax(
                            type: IdentifierTypeSyntax(name: TokenSyntax.identifier("Bool"))
                        )
                    ),
                    bodyBuilder: {
                        if properties.isEmpty {
                            BooleanLiteralExprSyntax(true)
                        } else {
                            SequenceExprSyntax(elements: ExprListSyntax {
                                for (i, property) in properties.enumerated() {
                                    ExprListSyntax {
                                        DeclReferenceExprSyntax(baseName: .identifier("lhs.\(property)"))
                                        BinaryOperatorExprSyntax(operator: .binaryOperator("=="))
                                        DeclReferenceExprSyntax(baseName: .identifier("rhs.\(property)"))
                                        if i != properties.indices.last {
                                            BinaryOperatorExprSyntax(operator: .binaryOperator("&&"), trailingTrivia: .newline)
                                        }
                                    }
                                }
                            })
                        }
                    }
                )
            }
        ]
    }
}
