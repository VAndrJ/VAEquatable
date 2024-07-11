/// Adds an extension with the static `==` function and `Equatable` conformance if needed.
///
/// ```swift
/// @Equatable
/// class SomeClass {
///     var a: Int
///
///     init(a: Int) {
///         self.a = a
///     }
/// }
///
/// // expands to
///
/// class SomeClass {
///     var a: Int
///
///     init(a: Int) {
///         self.a = a
///     }
/// }
///
/// extension SomeClass: Equatable {
///     static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
///         lhs.a == rhs.a
///     }
/// }
/// ```
@attached(extension, conformances: Equatable, names: named(==))
public macro Equatable(withComputed: Bool = false) = #externalMacro(module: "VAEquatableMacros", type: "VAEquatableMacro")
/// Macro to mark a field as ignored for the `@Equatable` macro.
@attached(peer)
public macro EquatableIgnored() = #externalMacro(module: "VAEquatableMacros", type: "VAEquatableIgnoredMacro")
/// Macro to mark a field as unique to use for the `@Equatable` macro.
@attached(peer)
public macro EquatableUnique() = #externalMacro(module: "VAEquatableMacros", type: "VAEquatableUniqueMacro")

/// Adds an extension with the `hash(into:)` function and `Hashable` conformance if needed.
///
/// ```swift
/// @Hashable
/// @Equatable
/// class SomeClass {
///     var a: Int
///
///     init(a: Int) {
///         self.a = a
///     }
/// }
///
/// // expands to
///
/// class SomeClass {
///     var a: Int
///
///     init(a: Int) {
///         self.a = a
///     }
/// }
///
/// extension SomeClass: Equatable {
///     static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
///         lhs.a == rhs.a
///     }
/// }
///
/// extension SomeClass: Hashable {
///     func hash(into hasher: inout Hasher) {
///         hasher.combine(a)
///     }
/// }
/// ```
@attached(extension, conformances: Hashable, names: named(hash))
public macro Hashable(withComputed: Bool = false) = #externalMacro(module: "VAEquatableMacros", type: "VAHashableMacro")
/// Macro to mark a field as ignored for the `@Hashable` macro.
@attached(peer)
public macro HashableIgnored() = #externalMacro(module: "VAEquatableMacros", type: "VAHashableIgnoredMacro")
/// Macro to mark a field as unique to use for the `@Hashable` macro.
@attached(peer)
public macro HashableUnique() = #externalMacro(module: "VAEquatableMacros", type: "VAHashableUniqueMacro")
