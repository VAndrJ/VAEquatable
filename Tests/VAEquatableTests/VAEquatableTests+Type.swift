//
//  VAEquatableTests+Type.swift
//  
//
//  Created by VAndrJ on 06.07.2024.
//

#if canImport(VAEquatableMacros)
import SwiftSyntaxMacrosTestSupport
import XCTest
import VAEquatableMacros

extension VAEquatableTests {

    func test_struct_failure() throws {
        assertMacroExpansion(
            """
            @Equatable
            struct SomeStruct {
                var a: Int
            }
            """,
            expandedSource: """
            struct SomeStruct {
                var a: Int
            }
            """,
            diagnostics: [DiagnosticSpec(message: VAEquatableError.notClass.description, line: 1, column: 1)],
            macros: testMacros
        )
    }

    func test_class_open_failure() throws {
        assertMacroExpansion(
            """
            @Equatable
            open class SomeClass {
            }
            """,
            expandedSource: """
            open class SomeClass {
            }
            """,
            diagnostics: [DiagnosticSpec(message: VAEquatableError.openModifier.description, line: 1, column: 1)],
            macros: testMacros
        )
    }

    func test_class_public() throws {
        assertMacroExpansion(
            """
            @Equatable
            public class SomeClass {
            }
            """,
            expandedSource: """
            public class SomeClass {
            }

            extension SomeClass: Equatable {
                public static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    true
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_class_internal() throws {
        assertMacroExpansion(
            """
            @Equatable
            internal class SomeClass {
            }
            """,
            expandedSource: """
            internal class SomeClass {
            }

            extension SomeClass: Equatable {
                internal static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    true
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_class_fileprivate() throws {
        assertMacroExpansion(
            """
            @Equatable
            fileprivate class SomeClass {
            }
            """,
            expandedSource: """
            fileprivate class SomeClass {
            }

            extension SomeClass: Equatable {
                fileprivate static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    true
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_class_final() throws {
        assertMacroExpansion(
            """
            @Equatable
            final class SomeClass {
            }
            """,
            expandedSource: """
            final class SomeClass {
            }

            extension SomeClass: Equatable {
                static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    true
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_class_equatable() throws {
        assertMacroExpansion(
            """
            @Equatable
            class SomeClass: Equatable {
            }
            """,
            expandedSource: """
            class SomeClass: Equatable {
            }

            extension SomeClass {
                static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    true
                }
            }
            """,
            macros: testMacros
        )
    }
}
#endif
