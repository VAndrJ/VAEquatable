import VAEquatable


@Hashable
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

assert(Set([value1, value2, value3]).count == 2)


@Hashable
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

assert(Set([value4, value5, value6]).count == 2)


@Hashable
@Equatable
class SomeClass2 {
    var a: Int
    @HashableIgnored
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

assert(Set([value7, value8, value9]).count == 2)


@Hashable(withComputed: true)
@Equatable(withComputed: true)
class SomeClass3 {
    var a: Int
    @HashableIgnored
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

assert(Set([value10, value11, value12]).count == 2)


@Hashable
@Equatable
class SomeClass4 {}

let value13 = SomeClass4()
let value14 = SomeClass4()

assert(value13 == value14)

assert(Set([value13, value14]).count == 1)


@Hashable
@Equatable
class SomeClass5 {
    let (a, b): (Int, Bool)

    init(a: Int, b: Bool) {
        (self.a, self.b) = (a, b)
    }
}

let value15 = SomeClass5(a: 1, b: false)
let value16 = SomeClass5(a: 1, b: true)
let value17 = SomeClass5(a: 2, b: true)
let value18 = SomeClass5(a: 1, b: false)

assert(value15 != value16)
assert(value15 != value17)
assert(value15 == value18)

assert(Set([value15, value16, value17, value18]).count == 3)


@Hashable
@Equatable
class SomeClass6 {
    var a, b: Int

    init(a: Int, b: Int) {
        self.a = a
        self.b = b
    }
}

let value19 = SomeClass6(a: 1, b: 1)
let value20 = SomeClass6(a: 1, b: 2)
let value21 = SomeClass6(a: 1, b: 1)

assert(value19 != value20)
assert(value19 == value21)

assert(Set([value19, value20, value21]).count == 2)


protocol SomeProtocol: Equatable, Hashable {}

@Hashable
@Equatable
class SomeClass7: SomeProtocol {
    @HashableUnique
    @EquatableUnique
    var id: String
    var a, b: Int

    init(id: String, a: Int, b: Int) {
        self.id = id
        self.a = a
        self.b = b
    }
}

let value22 = SomeClass7(id: "id1", a: 1, b: 1)
let value23 = SomeClass7(id: "id2", a: 2, b: 2)
let value24 = SomeClass7(id: "id1", a: 3, b: 3)

assert(value22 != value23)
assert(value22 == value24)

assert(Set([value22, value23, value24]).count == 2)

