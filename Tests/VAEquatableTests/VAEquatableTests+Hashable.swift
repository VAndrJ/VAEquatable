//
//  VAEquatableTests+Hashable.swift
//  VAEquatable
//
//  Created by VAndrJ on 11.07.2024.
//

#if canImport(VAEquatableMacros)
import SwiftSyntaxMacrosTestSupport
import XCTest
import VAEquatableMacros

extension VAEquatableTests {

    func test_hashable_class_empty() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            class SomeClass {
            }
            """,
            expandedSource: """
            class SomeClass {
            }
            
            extension SomeClass: Hashable {
                func hash(into hasher: inout Hasher) {
                }
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

    func test_hashable_class_property() throws {
        assertMacroExpansion(
            """
            @Hashable
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
            
            extension SomeClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
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

    func test_hashable_class_property_multiple() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            class SomeClass {
                var a: Int
                let b: Bool
                let (c, d): (String, Double)
                let e, f: UInt8
            
                init(a: Int, b: Bool, c: String, d: Double, e: UInt8, f: UInt8) {
                    self.a = a
                    self.b = b
                    self.c = c
                    self.d = d
                    self.e = e
                    self.f = f
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                var a: Int
                let b: Bool
                let (c, d): (String, Double)
                let e, f: UInt8
            
                init(a: Int, b: Bool, c: String, d: Double, e: UInt8, f: UInt8) {
                    self.a = a
                    self.b = b
                    self.c = c
                    self.d = d
                    self.e = e
                    self.f = f
                }
            }
            
            extension SomeClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
                    hasher.combine(b)
                    hasher.combine(c)
                    hasher.combine(d)
                    hasher.combine(e)
                    hasher.combine(f)
                }
            }
            
            extension SomeClass: Equatable {
                static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
                    lhs.a == rhs.a &&
                    lhs.b == rhs.b &&
                    lhs.c == rhs.c &&
                    lhs.d == rhs.d &&
                    lhs.e == rhs.e &&
                    lhs.f == rhs.f
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_hashable_class_property_public() throws {
        assertMacroExpansion(
            """
            @Hashable
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
            
            extension SomeClass: Hashable {
                public func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
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

    func test_hashable_class_property_public_privateset() throws {
        assertMacroExpansion(
            """
            @Hashable
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
            
            extension SomeClass: Hashable {
                public func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
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

    func test_hashable_class_property_other() throws {
        assertMacroExpansion(
            """
            @Hashable
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
            
            extension SomeClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
                    hasher.combine(b)
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

    func test_hashable_class_property_computed_false() throws {
        assertMacroExpansion(
            """
            @Hashable(withComputed: false)
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
                var c: String {
                    get { _c }
                    set {}
                }
            
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
                var c: String {
                    get { _c }
                    set {}
                }
            
                init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                    self._c = "random"
                }
            }
            
            extension SomeClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
                    hasher.combine(b)
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

    func test_hashable_class_property_computed_true() throws {
        assertMacroExpansion(
            """
            @Hashable(withComputed: true)
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
            
            extension SomeClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
                    hasher.combine(b)
                    hasher.combine(computed)
                    hasher.combine(c)
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

    func test_hashable_class_property_multiple_bindings() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            class SomeClass {
                let a, b: Int
            
                init(a: Int, b: Int) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                let a, b: Int
            
                init(a: Int, b: Int) {
                    self.a = a
                    self.b = b
                }
            }
            
            extension SomeClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
                    hasher.combine(b)
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

    func test_hashable_class_property_tuple_bindings() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            class SomeClass {
                let (a, b): (Int, Bool)
            
                init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                let (a, b): (Int, Bool)
            
                init(a: Int, b: Bool) {
                    self.a = a
                    self.b = b
                }
            }
            
            extension SomeClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
                    hasher.combine(b)
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

    func test_hashable_class_property_unique() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            class SomeClass {
                @HashableUnique
                @EquatableUnique
                let a: Int
                let b: Int
            
                init(a: Int, b: Int) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                let a: Int
                let b: Int
            
                init(a: Int, b: Int) {
                    self.a = a
                    self.b = b
                }
            }
            
            extension SomeClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
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

    func test_hashable_class_property_ignored() throws {
        assertMacroExpansion(
            """
            @Hashable(withComputed: true)
            @Equatable(withComputed: true)
            class SomeClass {
                var a: Int {
                    willSet { print(newValue) }
                    didSet { print(oldValue) }
                }
                @HashableIgnored
                @EquatableIgnored
                let b = true
                private var _c: String
                @HashableIgnored
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
            
            extension SomeClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
                    hasher.combine(c)
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

    func test_hashable_struct_failure() throws {
        assertMacroExpansion(
            """
            @Hashable
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
            diagnostics: [
                DiagnosticSpec(message: VAEquatableError.notClass.description, line: 1, column: 1),
                DiagnosticSpec(message: VAEquatableError.notClass.description, line: 2, column: 1),
            ],
            macros: testMacros
        )
    }

    func test_hashable_class_open_failure() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            open class SomeClass {
            }
            """,
            expandedSource: """
            open class SomeClass {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: VAEquatableError.openModifier.description, line: 1, column: 1),
                DiagnosticSpec(message: VAEquatableError.openModifier.description, line: 2, column: 1),
            ],
            macros: testMacros
        )
    }

    func test_hashable_class_public() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            public class SomeClass {
            }
            """,
            expandedSource: """
            public class SomeClass {
            }
            
            extension SomeClass: Hashable {
                public func hash(into hasher: inout Hasher) {
                }
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

    func test_hashable_class_internal() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            internal class SomeClass {
            }
            """,
            expandedSource: """
            internal class SomeClass {
            }
            
            extension SomeClass: Hashable {
                internal func hash(into hasher: inout Hasher) {
                }
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

    func test_hashable_class_fileprivate() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            fileprivate class SomeClass {
            }
            """,
            expandedSource: """
            fileprivate class SomeClass {
            }
            
            extension SomeClass: Hashable {
                fileprivate func hash(into hasher: inout Hasher) {
                }
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

    func test_hashable_class_final() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            final class SomeClass {
            }
            """,
            expandedSource: """
            final class SomeClass {
            }
            
            extension SomeClass: Hashable {
                func hash(into hasher: inout Hasher) {
                }
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

    func test_hashable_class_equatable() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            class SomeClass: Equatable, Hashable {
            }
            """,
            expandedSource: """
            class SomeClass: Equatable, Hashable {
            }
            
            extension SomeClass {
                func hash(into hasher: inout Hasher) {
                }
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

    func test_hashable_class_hashable() throws {
        assertMacroExpansion(
            """
            @Hashable
            @Equatable
            class SomeClass: Hashable, Equatable {
            }
            """,
            expandedSource: """
            class SomeClass: Hashable, Equatable {
            }
            
            extension SomeClass {
                func hash(into hasher: inout Hasher) {
                }
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
