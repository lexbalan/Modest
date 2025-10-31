
# *Cons* value expression


## Explicit value construction
*Explicit value construction* operation creates new value based on another.

### Common form
```
<#type#> <#value_expression#>
```


```swift
// fast example
// construct values from literal values with generic-type
const i = Int32 1234
const n = Nat16 0xFFFF
const f = Float64 0.1234
const c = Char32 "A"
const r = Point {x=0, y=0}
const a = [2]Point [{x=0, y=0}, {x=1, y=1}]
const p = *Point nil
```



```swift
// example: explicit cons integer values

var i: Int32
var j: Int64

i = Int32 j
j = Int64 i
var k = Nat128 i
```


```swift
// example: explicit cons array from incomplete array

var a: [10]Int32
// you can't implicitly cons [10]Int from [3]Int
// but you can do it explicitly (extra items will be filled with zeros)
a = [10]Int32 [1, 2, 3]
```

```swift
// example: explicit cons record from incomplete record

type Point3D record {x: Int32, y: Int32, z: Int32}

var r: Point3D
// you can't implicitly cons record {x: Int32, y: Int32, z: Int32} 
// from {x: GenericInteger} but you can do it explicitly
// (all rest fields will be filled with zeros)
r = Point3D {x=10}
```




| Cons Value Type | Allowable argument type | Action | Comment |
| ---- | ---------------------------------- | --- | --- |
| **Unit** | *Any* | Annihilation of argument value | Can be constructed from any type. Used for warning suppression |
| **Bool** | **Word8**, **Int**Y, **Nat**Y | returns ***true*** if argument != 0, else - ***false*** | |
| **Word8** | **Bool**, **Int**Y, **Nat**Y | Word8 representation of argument lower byte | Requires *unsafe* feature for warning suppression |
| **Char**X | **Int**Y, **Nat**Y | Creating character value with the same code as argument | Compiler error if Y != X |
| **Int**X | **Bool**, **Word8**, **Nat**Y, **Float**Z | - | Compiler warning if Y > X |
| **Nat**X | **Bool**, **Word8**, **Int**Y, **Float**Z | - | Compiler warning if Y > X |
| **Float**X | **Int**Y, **Nat**Y, **Float**Y | - | - |
| ***Record*** | | | - |
| ***Array*** | | | - |
| ***Pointer*** | | | - |




## Implicit value construction

### Implicit value construction from *generic*-type value

Value can be implicitly constructed from another value with *generic* type

| **Generic type** | **Can be implicitly cast to** |
| :--------------: | :---------------------: |
| Generic Integer  | Word8, Char, Integer, Float |
| Generic Float	| Float |
| Generic Char	 | Char |
| Generic Array	| Array, Pointer to Array |
| Generic Record   | Record, Pointer to Record |


```swift
// example: cons Int from GenericInteger

var i: Int32

// implicit cons Int32 value '1' from literal value with GenericInteger type
i = 1
```


```swift
// example: cons Array from GenericArray

var a: [3]Int32

// implicit cons [3]Int32 array value from Generic[3]GenericInteger literal
a = [1, 2, 3]
```


```swift
// example: cons Record from GenericRecord

var r: record {x: Int32, y: Int32}

// implicit cons value with type record {x: Int32, y: Int32}
// from literal record value {x=0, y=0}
// with type GenericRecord {x: Int32, y: Int32}
r = {x = 0, y = 0}
```

### Implicit cast 'pointer to sized array' -> 'pointer to unsized array'


```swift
// example: cons pointer to unsized array from Pointer to sized array

var a: *[5]Int32
var pa: *[]Int32

// implicit cons value with type *[]Int32
// from value with type *[3]Int32
pa = &a
```

