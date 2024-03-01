# Generic types


*Generic type* - compile time type, that can be *implicitly* casted to *Non-Generic types* for using in runtime.

| GenericType | Represented Value | Examples |
| ----------- | ----------- | -------- |
| `GenericInteger` | integer literal | `0, 1, 2, ...` |
| `GenericFloat` | floating point literal | `0.5, 2.7, 3.14, ...` |
| `GenericChar` | char expression | `"a"[0], "b"[0], ...` |
| `GenericArray` | array expression | `[1, 2, 3], [1], ...` |
| `GenericRecord` | record expression | `{x=1, y=2, z=3}, {a=10, b=20}, ...` |


## Generic Integer

*Generic integer* value can be implicitly casted to *Integer*, *Float* and *Byte* types, and explicitly to *Unit*, *Bool* and *Char*.


#### Example
```swift
func main() -> Int {
    // integer literal have GenericInteger type
    let one = 1

    // result of such expressions also have generic type
    let two = 1 + one

    // GenericInteger value can be implicitly casted to any Integer
    var a: Int32 = one  // implicit cast GenericInteger value to Int32
    var b: Nat64 = one  // implicit cast GenericInteger value to INat64
    ...

    // to Float
    var f: Float32 = one  // implicit cast GenericInteger value to Float32
    var g: Float64 = one  // implicit cast GenericInteger value to Float64

    // and to Byte (only if value is in range 0 .. 255)
    var x: Byte = one  // implicit cast GenericInteger value to Byte


    // explicit cast GenericInteger value

    var c: Char8 = one to Char8    // explicit cast GenericInteger value to Char8
    var d: Char16 = one to Char16  // explicit cast GenericInteger value to Char16
    var e: Char32 = one to Char32  // explicit cast GenericInteger value to Char32

    var k: Bool = one to Bool  // explicit cast GenericInteger value to Bool

    return 0
}

```

## Generic Float

*Generic float* value can be implicitly casted to *Float* type, and explicitly to *Unit* and *Integer*.

#### Example
```swift
func main() -> Int {
    // float literal have GenericFloat type
    let pi = 3.141592653589793238462643383279502884

    // value with GenericFloat type
    // can be implicit casted to any Float type
    // (in this case value may lose precision)
    var f: Float32 = pi  // implicit cast GenericFloat value to Float32
    var g: Float64 = pi  // implicit cast GenericFloat value to Float64

    // explicit cast GenericFloat value to Int32
    var x: Int32 = pi to Int32

    return 0
}

```


## Generic Char

*Generic char* value can be implicitly casted to *Char* type, and explicitly to *Unit* and *Integer*. In compiler generic char have 32-bit representation.

#### Example
```swift
func main() -> Int {
    // char literal have GenericChar type
    // (you can pick GenericChar value by index of GenericString value)
    let a = "A"[0]

    // value with GenericChar type
    // can be implicit casted to any Char type
    var b: Char8 = a   // implicit cast GenericChar value to Char8
    var c: Char16 = a  // implicit cast GenericChar value to Char16
    var d: Char32 = a  // implicit cast GenericChar value to Char32

    // explicit cast GenericChar value to Int32
    var char_code: Int32 = a to Int32

    return 0
}

```


## Generic Array
## Generic Record