import SwiftSyntaxMacros
import XCTest

#if canImport(VAEquatableMacros)
import VAEquatableMacros

let testMacros: [String: Macro.Type] = [
    "Equatable": VAEquatableMacro.self,
    "EquatableIgnored": VAEquatableIgnoredMacro.self,
]
#endif

final class VAEquatableTests: XCTestCase {}
