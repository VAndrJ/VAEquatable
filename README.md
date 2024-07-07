# VAEquatable


[![StandWithUkraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)
[![Support Ukraine](https://img.shields.io/badge/Support-Ukraine-FFD500?style=flat&labelColor=005BBB)](https://opensource.fb.com/support-ukraine)


[![Language](https://img.shields.io/badge/language-Swift%205.9-orangered.svg?style=flat)](https://www.swift.org)
[![SPM](https://img.shields.io/badge/SPM-compatible-limegreen.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20macOS%20%7C%20macCatalyst-lightgray.svg?style=flat)](https://developer.apple.com/discover)


### @Equatable


Adds an extension with the static `==` function and `Equatable` conformance if needed.


Example 1:


```swift
@Equatable
class SomeClass {
    var a: Int

    init(a: Int) {
        self.a = a
    }
}

// expands to

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
```


Example 2:


```swift
@Equatable
public class SomeClass {
    public var a: Int
    var b: Bool

    public init(a: Int, b: Bool) {
        self.a = a
        self.b = b
    }
}

// expands to

public class SomeClass {
    public var a: Int
    var b: Bool

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
```


Example 3:


```swift
@Equatable
class SomeClass {
    var a: Int
    @EquatableIgnored
    var b: Bool
    var c: Bool { true }

    init(a: Int, b: Bool) {
        self.a = a
        self.b = b
    }
}

// expands to

class SomeClass {
    var a: Int
    @EquatableIgnored
    var b: Bool
    var c: Bool { true }

    init(a: Int, b: Bool) {
        self.a = a
        self.b = b
    }
}

extension SomeClass: Equatable {
    static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
        lhs.a == rhs.a
    }
}
```


Example 4:


```swift
@Equatable(withComputed: true)
class SomeClass {
    var a: Int
    @EquatableIgnored
    var b: Bool
    var c: String {
        get { _c }
        set { _c = newValue }
    }
    
    private var _c: String

    init(a: Int, b: Bool, c: String) {
        self.a = a
        self.b = b
        self._c = c
    }
}

// expands to

class SomeClass {
    var a: Int
    @EquatableIgnored
    var b: Bool
    var c: String {
        get { _c }
        set { _c = newValue }
    }
    
    private var _c: String

    init(a: Int, b: Bool, c: String) {
        self.a = a
        self.b = b
        self._c = c
    }
}

extension SomeClass: Equatable {
    static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
        lhs.a == rhs.a &&
        lhs.c == rhs.c
    }
}
```


Example 5:


```swift
@Equatable
class SomeClass {}

// expands to

class SomeClass {}

extension SomeClass: Equatable {
    static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
        true
    }
}
```


## Author


Volodymyr Andriienko, vandrjios@gmail.com


## License


VAEquatable is available under the MIT license. See the LICENSE file for more info.
