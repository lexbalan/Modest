# Generic types


*Generic type* - compile time type, that can be *implicit* casted to *Non-Generic types* for using in runtime.

| GenericType | Represented Value | Examples |
| ----------- | ----------- | -------- |
| `GenericInteger` | integer literal | `0, 1, 2, ...` |
| `GenericFloat` | floating point literal | `0.5, 2.7, 3.14, ...` |
| `GenericChar` | char expression | `"a"[0], "b"[0], ...` |
| `GenericArray` | array expression | `[1, 2, 3], [1], ...` |
| `GenericRecord` | record expression | `{x=1, y=2, z=3}, {a=10, b=20}, ...` |


## Generic Integer

Generic integer value can be implicit casted to Integer, Float and Byte types


#### Example
```swift
func main() -> Int {
    // integer literal have GenericInteger type
    let valueOneWithGenericIntegerType = 1

    // value with generic-type can be implicit casted to non-generic
    // GenericInteger value can be casted to Integer:
    var a: Int32 = valueOneWithGenericIntegerType
    var b: Nat64 = valueOneWithGenericIntegerType

    // to Float
    var f: Float32 = valueOneWithGenericIntegerType
    var g: Float64 = valueOneWithGenericIntegerType

    // and to Byte (only if value is in range 0 .. 255)
    var b: Byte = valueOneWithGenericIntegerType

    return 0
}

```

## Generic Float
## Generic Char
## Generic Array
## Generic Record