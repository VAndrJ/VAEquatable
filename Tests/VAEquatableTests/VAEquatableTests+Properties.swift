//
//  VAEquatableTests+Properties.swift
//  
//
//  Created by VAndrJ on 06.07.2024.
//

#if canImport(VAEquatableMacros)
import SwiftSyntaxMacrosTestSupport
import XCTest
import VAEquatableMacros

extension VAEquatableTests {

    func test_class_empty() throws {
        assertMacroExpansion(
            """
            @Equatable
            class SomeClass {
            }
            """,
            expandedSource: """
            class SomeClass {
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

    func test_class_property() throws {
        assertMacroExpansion(
            """
            @Equatable
            class SomeClass {
                var a: Int

                init(a: Int) {
                    self.a = a
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                var a: Int

                init(a: Int) {
                    self.a = a
                }
            }

            extension SomeClass: Equatable {
                static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    lhs.a == rhs.a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_class_property_multiple() throws {
        assertMacroExpansion(
            """
            @Equatable
            class SomeClass {
                var a: Int
                let b: Bool

                init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                var a: Int
                let b: Bool

                init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                }
            }

            extension SomeClass: Equatable {
                static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    lhs.a == rhs.a &&
                    lhs.b == rhs.b
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_class_property_public() throws {
        assertMacroExpansion(
            """
            @Equatable
            public class SomeClass {
                public var a: Int
                let b: Bool

                public init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            expandedSource: """
            public class SomeClass {
                public var a: Int
                let b: Bool

                public init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                }
            }

            extension SomeClass: Equatable {
                public static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    lhs.a == rhs.a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_class_property_public_privateset() throws {
        assertMacroExpansion(
            """
            @Equatable
            public class SomeClass {
                public private(set) var a: Int
                let b: Bool

                public init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            expandedSource: """
            public class SomeClass {
                public private(set) var a: Int
                let b: Bool

                public init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                }
            }

            extension SomeClass: Equatable {
                public static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    lhs.a == rhs.a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_class_property_other() throws {
        assertMacroExpansion(
            """
            @Equatable
            class SomeClass {
                static let staticProperty = 3
                class var classProperty = false

                var a: Int {
                    willSet { print(newValue) }
                    didSet { print(oldValue) }
                }
                let b: Bool
                private let c: String

                var computed: String { String(a) }

                init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                    self.c = "random"
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                static let staticProperty = 3
                class var classProperty = false

                var a: Int {
                    willSet { print(newValue) }
                    didSet { print(oldValue) }
                }
                let b: Bool
                private let c: String

                var computed: String { String(a) }

                init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                    self.c = "random"
                }
            }

            extension SomeClass: Equatable {
                static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    lhs.a == rhs.a &&
                    lhs.b == rhs.b
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_class_property_computed_false() throws {
        assertMacroExpansion(
            """
            @Equatable(withComputed: false)
            class SomeClass {
                static let staticProperty = 3
                class var classProperty = false

                var a: Int {
                    willSet { print(newValue) }
                    didSet { print(oldValue) }
                }
                let b: Bool
                private let _c: String

                var computed: String { String(a) }
                var c: String { _c }

                init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                    self._c = "random"
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                static let staticProperty = 3
                class var classProperty = false

                var a: Int {
                    willSet { print(newValue) }
                    didSet { print(oldValue) }
                }
                let b: Bool
                private let _c: String

                var computed: String { String(a) }
                var c: String { _c }

                init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                    self._c = "random"
                }
            }

            extension SomeClass: Equatable {
                static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    lhs.a == rhs.a &&
                    lhs.b == rhs.b
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_class_property_computed_true() throws {
        assertMacroExpansion(
            """
            @Equatable(withComputed: true)
            class SomeClass {
                static let staticProperty = 3
                class var classProperty = false

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
            """,
            expandedSource: """
            class SomeClass {
                static let staticProperty = 3
                class var classProperty = false

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
                    lhs.b == rhs.b &&
                    lhs.computed == rhs.computed &&
                    lhs.c == rhs.c
                }
            }
            """,
            macros: testMacros
        )
    }
}
#endif
