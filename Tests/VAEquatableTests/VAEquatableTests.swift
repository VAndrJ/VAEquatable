#if canImport(VAEquatableMacros)
import SwiftSyntaxMacros
import XCTest
import VAEquatableMacros

let testMacros: [String: Macro.Type] = [
    "Equatable": VAEquatableMacro.self,
    "EquatableIgnored": VAEquatableIgnoredMacro.self,
    "EquatableUnique": VAEquatableUniqueMacro.self,
    "Hashable": VAHashableMacro.self,
    "HashableIgnored": VAHashableIgnoredMacro.self,
    "HashableUnique": VAHashableUniqueMacro.self,
]

final class VAEquatableTests: XCTestCase {}
#endif
