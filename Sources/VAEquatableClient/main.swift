import VAEquatable


@Equatable
class SomeClass {
    var a: Int

    init(a: Int) {
        self.a = a
    }
}

let value1 = SomeClass(a: 1)
let value2 = SomeClass(a: 2)
let value3 = SomeClass(a: 1)

assert(value1 != value2)
assert(value1 == value3)


@Equatable
public class SomeClass1 {
    public var a: Int
    var b: Bool

    public init(a: Int, b: Bool) {
        self.a = a
        self.b = b
    }
}

let value4 = SomeClass1(a: 1, b: true)
let value5 = SomeClass1(a: 2, b: true)
let value6 = SomeClass1(a: 1, b: false)

assert(value4 != value5)
assert(value4 == value6)


@Equatable
class SomeClass2 {
    var a: Int
    @EquatableIgnored
    var b: Bool
    var c: Bool { true }

    init(a: Int, b: Bool) {
        self.a = a
        self.b = b
    }
}

let value7 = SomeClass2(a: 1, b: true)
let value8 = SomeClass2(a: 2, b: true)
let value9 = SomeClass2(a: 1, b: false)

assert(value7 != value8)
assert(value7 == value9)


@Equatable(withComputed: true)
class SomeClass3 {
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

let value10 = SomeClass3(a: 1, b: true, c: "1")
let value11 = SomeClass3(a: 2, b: true, c: "2")
let value12 = SomeClass3(a: 1, b: true, c: "1")

assert(value10 != value11)
assert(value10 == value12)


@Equatable
class SomeClass4 {}

let value13 = SomeClass4()
let value14 = SomeClass4()

assert(value13 == value14)
