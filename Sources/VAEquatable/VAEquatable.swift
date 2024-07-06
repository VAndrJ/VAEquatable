@attached(extension, conformances: Equatable, names: named(==))
public macro Equatable(withComputed: Bool = false) = #externalMacro(module: "VAEquatableMacros", type: "VAEquatableMacro")
@attached(peer)
public macro EquatableIgnored() = #externalMacro(module: "VAEquatableMacros", type: "VAEquatableIgnoredMacro")
