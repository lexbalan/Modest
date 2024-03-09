
# *Cons* value expression


## Implicit value construction

### Implicit value construction *generic*-type value

Value can be implicitly constructed from another value with *generic* type

| **Generic type** | **Can be implicitly cast to** |
| :--------------: | :---------------------: |
| Generic Integer  | Byte, Char, Integer, Float |
| Generic Float    | Float |
| Generic Char     | Char |
| Generic Array    | Array, Pointer to Array |
| Generic Record   | Record, Pointer to Record |



```zig
// example: cons Int from GenericInteger

var i: Int32

// implicit cons Int32 value '1' from literal value with GenericInteger type
i = 1
```


```zig
// example: cons Array from GenericArray

var a: [3]Int32

// implicit cons [3]Int32 array value from Generic[3]GenericInteger literal
a = [1, 2, 3]
```


```zig
// example: cons Record from GenericRecord

var r: record {x: Int32, y: Int32}

// implicit cons value with type record {x: Int32, y: Int32}
// from literal record value {x=0, y=0}
// with type GenericRecord {x: Int32, y: Int32}
r = {x = 0, y = 0}
```

### Implicit cast 'pointer to sized array' -> 'pointer to unsized array'


```zig
// example: cons pointer to unsized array from Pointer to sized array

var a: *[5]Int32
var pa: *[]Int32

// implicit cons value with type *[]Int32
// from value with type *[3]Int32
pa = &a
```


## Explicit type casting

### Common form
```
<#type#> <#value_expression#>
```


```swift
Int32 1234
Nat16 0xFFFF
Float64 0.1234
Char32 "A"
```

All other kinds of type casting requires explicit type cast operator

```zig
// example: explicit cons integer values

var i: Int32
var j: Int64

i = Int32 j
j = Int64 i
```

```zig
// example: explicit cons array

var a: [10]Int32
// you can't implicit cast [3]Int -> [10]Int
// but you can do explicit cast (all rest items will be filled with zeros)
a = [10]Int32 [1, 2, 3]
```

```zig
// example: explicit cast incomplete record

type Point3D record {x: Int32, y: Int32, z: Int32}

var r: Point3D
// you can't implicit cast {x: GenericInteger} -> record {x: Int32, y: Int32, z: Int32}
// but you can do explicit cast (all rest fields will be filled with zeros)
r = Point3D {x=0}
```