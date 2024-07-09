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
private let willSetKeyword: TokenKind = .keyword(.willSet)
private let didSetKeyword: TokenKind = .keyword(.didSet)
private let getKeyword: TokenKind = .keyword(.get)
private let setKeyword: TokenKind = .keyword(.set)

public extension VariableDeclSyntax {
    var isPublic: Bool { modifiers.contains { $0.name.tokenKind == publicKeyword } }
    var isPrivate: Bool { modifiers.contains { $0.name.tokenKind == privateKeyword } && !isPublic }
    var isStatic: Bool { modifiers.contains { $0.name.tokenKind == staticKeyword } }
    var isClass: Bool { modifiers.contains { $0.name.tokenKind == classKeyword } }
    var isInstance: Bool { !(isClass || isStatic) }
    func getIsStored(orComputed: Bool) throws -> Bool {
        guard isInstance, let binding = bindings.first else {
            return false
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
    var names: [String] {
        var names: [String] = []
        for binding in bindings {
            if let name = binding.pattern.name {
                names.append(name)
            } else if let elements = binding.pattern.as(TuplePatternSyntax.self)?.elements {
                names.append(contentsOf: elements.compactMap(\.pattern.name))
            }
        }

        return names
    }
}

extension PatternSyntax {
    var name: String? { self.as(IdentifierPatternSyntax.self)?.identifier.text }
}

extension String {
    static let equatable = "Equatable"
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

extension [VariableDeclSyntax] {

    var names: [String] {
        let unique = filter { $0.attributes.isUnique }
        if unique.isEmpty {
            return flatMap(\.names)
        } else {
            return unique.flatMap(\.names)
        }
    }
}

extension AttributeListSyntax {
    var isIgnored: Bool { contains(where: { $0.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "EquatableIgnored" }) }
    var isUnique: Bool { contains(where: { $0.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "EquatableUnique" }) }
}

public extension DeclModifierListSyntax {
    var accessModifier: DeclModifierListSyntax {
        DeclModifierListSyntax(compactMap { declModifierSyntax in
            switch declModifierSyntax.name.tokenKind {
            case let .keyword(keyword):
                switch keyword {
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
