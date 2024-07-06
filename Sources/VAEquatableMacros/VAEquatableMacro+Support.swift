//
//  VAEquatableMacro+Support.swift
//  
//
//  Created by VAndrJ on 06.07.2024.
//

import SwiftSyntax

private let publicKeyword: TokenKind = .keyword(.public)
private let privateKeyword: TokenKind = .keyword(.private)
private let staticKeyword: TokenKind = .keyword(.static)
private let classKeyword: TokenKind = .keyword(.class)
private let varKeyword: TokenKind = .keyword(.var)
private let letKeyword: TokenKind = .keyword(.let)
private let willSetKeyword: TokenKind = .keyword(.willSet)
private let didSetKeyword: TokenKind = .keyword(.didSet)
private let getKeyword: TokenKind = .keyword(.get)
private let setKeyword: TokenKind = .keyword(.set)

public extension VariableDeclSyntax {
    var isPublic: Bool { modifiers.contains { $0.name.tokenKind == publicKeyword } }
    var isPrivate: Bool { modifiers.contains { $0.name.tokenKind == privateKeyword } && !isPublic }
    var isLet: Bool { bindingSpecifier.tokenKind == letKeyword }
    var isVar: Bool { bindingSpecifier.tokenKind == varKeyword }
    var isStatic: Bool { modifiers.contains { $0.name.tokenKind == staticKeyword } }
    var isClass: Bool { modifiers.contains { $0.name.tokenKind == classKeyword } }
    var isInstance: Bool { !(isClass || isStatic) }
    func getIsStored(orComputed: Bool) throws -> Bool {
        guard isInstance else {
            return false
        }
        guard bindings.count == 1, let binding = bindings.first else {
            throw VAEquatableError.multipleBindings
        }

        switch binding.accessorBlock?.accessors {
        case let .accessors(node):
            for accessor in node {
                switch accessor.accessorSpecifier.tokenKind {
                case willSetKeyword, didSetKeyword:
                    continue
                case getKeyword, setKeyword:
                    if orComputed {
                        continue
                    } else {
                        return false
                    }
                default:
                    return false
                }
            }

            return true
        case .getter:
            return orComputed
        case .none:
            return true
        }
    }
    var name: String? {
        guard bindings.count == 1,
              let binding = bindings.first,
              let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
            return nil
        }

        return name
    }
    var nameWithType: (name: String, type: TypeSyntax)? {
        guard bindings.count == 1,
              let binding = bindings.first,
              let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
            return nil
        }

        if let type = binding.typeAnnotation?.type {
            return (name, type)
        } else if let initializer = binding.initializer?.value {
            if let type = initializer.literalOrExprType {
                return (name, type)
            } else if let member = initializer.as(ArrayExprSyntax.self)?.elements.first?.expression.literalOrExprType {
                return (name, TypeSyntax("[\(raw: member.description)]"))
            } else if let dict = initializer.as(DictionaryExprSyntax.self)?.content.as(DictionaryElementListSyntax.self)?.first, let key = dict.key.literalOrExprType, let value = dict.value.literalOrExprType {
                return (name, TypeSyntax("[\(raw: key.description): \(raw: value.description)]"))
            }
        }

        return nil
    }
}

extension LabeledExprListSyntax {
    var withComputedParam: Bool {
        guard let withComputed = getLabeledExprSyntax("withComputed")?.expression.as(BooleanLiteralExprSyntax.self)?.literal.text else {
            return false
        }
        
        return withComputed == "true"
    }

    private func getLabeledExprSyntax(_ text: String) -> LabeledExprSyntax? {
        first(where: { $0.label?.text == text })
    }
}

extension LabeledExprSyntax {
    var string: String? { self.expression.as(StringLiteralExprSyntax.self)?.segments.first?.trimmedDescription }
    var memberExpr: MemberAccessExprSyntax? { self.expression.as(MemberAccessExprSyntax.self) }
    var member: String? { memberExpr?.trimmedDescription }
    var memberBase: String? { memberExpr?.base?.trimmedDescription }
    var decl: String? { self.expression.as(DeclReferenceExprSyntax.self)?.trimmedDescription }
    var function: String? { self.expression.as(FunctionCallExprSyntax.self)?.trimmedDescription }
}

public extension ExprSyntax {
    var literalOrExprType: TypeSyntax? {
        if self.is(StringLiteralExprSyntax.self) {
            return TypeSyntax("String")
        } else if self.is(IntegerLiteralExprSyntax.self) {
            return TypeSyntax("Int")
        } else if self.is(BooleanLiteralExprSyntax.self) {
            return TypeSyntax("Bool")
        } else if self.is(FloatLiteralExprSyntax.self) {
            return TypeSyntax("Double")
        } else if let member = self.as(MemberAccessExprSyntax.self)?.base?.description {
            return TypeSyntax("\(raw: member)")
        } else if let expr = self.as(FunctionCallExprSyntax.self), let member = expr.calledExpression.as(MemberAccessExprSyntax.self)?.base?.description ?? expr.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text {
            if member == "Optional" {
                if let argumentType = expr.arguments.first?.expression.literalOrExprType {
                    return TypeSyntax("\(raw: argumentType)?")
                }
            } else {
                return TypeSyntax("\(raw: member)")
            }
        }

        return nil
    }
}

public extension TypeSyntax {
    var isOptional: Bool { self.is(OptionalTypeSyntax.self) }
    var nonOptional: TypeSyntax { self.as(OptionalTypeSyntax.self)?.wrappedType.trimmed ?? self.trimmed }
}

public extension DeclGroupSyntax {

    func getProperties(withComputed: Bool, isPublic: Bool) throws -> [VariableDeclSyntax] {
        try memberBlock.members.compactMap { member -> VariableDeclSyntax? in
            guard let variable = member.decl.as(VariableDeclSyntax.self),
                  !variable.isPrivate,
                  isPublic && variable.isPublic || !isPublic,
                  try variable.getIsStored(orComputed: withComputed) else {
                return nil
            }
            guard !variable.attributes.isIgnored else {
                return nil
            }

            return variable
        }
    }
}

extension AttributeListSyntax {
    var isIgnored: Bool { contains(where: { $0.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "EquatableIgnored" }) }
}

public extension DeclModifierListSyntax {
    var accessModifier: DeclModifierListSyntax {
        DeclModifierListSyntax(compactMap { declModifierSyntax in
            switch declModifierSyntax.name.tokenKind {
            case let .keyword(keyword):
                switch keyword {
                case .open: DeclModifierSyntax(name: .keyword(.public))
                case .public, .fileprivate, .internal: declModifierSyntax
                default: nil
                }
            default: nil
            }
        })
    }
    var isOpen: Bool { contains(where: { $0.name.tokenKind == .keyword(.open) }) }
    var isPublic: Bool { contains(where: { $0.name.tokenKind == .keyword(.public) }) }
}
