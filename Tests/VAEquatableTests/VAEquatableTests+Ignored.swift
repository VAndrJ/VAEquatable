//
//  VAEquatableTests+Ignored.swift
//
//
//  Created by VAndrJ on 06.07.2024.
//

#if canImport(VAEquatableMacros)
import SwiftSyntaxMacrosTestSupport
import XCTest
import VAEquatableMacros

extension VAEquatableTests {

    func test_class_property_ignored() throws {
        assertMacroExpansion(
            """
            @Equatable(withComputed: true)
            class SomeClass {
                var a: Int {
                    willSet { print(newValue) }
                    didSet { print(oldValue) }
                }
                @EquatableIgnored
                let b = true
                private var _c: String
                @EquatableIgnored
                var computed: String { String(a) }
                var c: String {
                    get { _c }
                    set { _c = newValue }
                }

                init(a: Int) {
                    self.a = a
                    self._c = "random"
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                var a: Int {
                    willSet { print(newValue) }
                    didSet { print(oldValue) }
                }
                let b = true
                private var _c: String
                var computed: String { String(a) }
                var c: String {
                    get { _c }
                    set { _c = newValue }
                }

                init(a: Int) {
                    self.a = a
                    self._c = "random"
                }
            }

            extension SomeClass: Equatable {
                static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    lhs.a == rhs.a &&
                    lhs.c == rhs.c
                }
            }
            """,
            macros: testMacros
        )
    }
}
#endif
