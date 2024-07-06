//
//  VAEquatableError.swift
//  
//
//  Created by VAndrJ on 06.07.2024.
//

public enum VAEquatableError: Error, CustomStringConvertible {
    case notClass
    case multipleBindings
    case openModifier

    public var description: String {
        switch self {
        case .notClass: "Must be `class` declaration"
        case .multipleBindings: "Use single variable"
        case .openModifier: "Must not be `open`"
        }
    }
}
