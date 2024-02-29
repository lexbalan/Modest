
# *Cast* value expression


### Common form
```
<#value_expression#> to <#type#>
```
> This syntactic form is not very good, and will probably be changed to a more convenient one later


## Implicit type casting

### Implicit cast *generic* -> *non-generic* type

Generic types can be implicitly casted to corresponded type

| **Generic type** | **Can be implicit cast to** |
| :--------------: | :---------------------: |
| Generic Integer  | Byte, Char, Integer, Float |
| Generic Float    | Float |
| Generic Char     | Char |
| Generic Array    | Array, Pointer to Array |
| Generic Record   | Record, Pointer to Record |



```zig
// example: GenericInteger -> Int

var i: Int32

// implicit cast literal numeric value '1' with type GenericInteger to type Int32 
i = 1
```


```zig
// example: GenericArray -> Array

var a: [3]Int32

// implicit cast literal array value '[1, 2, 3]' with type Generic[3]GenericInteger to type [3]Int32
a = [1, 2, 3]
```


```zig
// example: GenericRecord -> Record

var r: record {x: Int32, y: Int32}

// implicit cast literal record value {x=0, y=0} with type GenericRecord {x: Int32, y: Int32}
// to type record {x: Int32, y: Int32}
r = {x = 0, y = 0}
```

### Implicit cast 'pointer to sized array' -> 'pointer to unsized array'


```zig
// example: Pointer to sized array -> pointer to unsized array

var a: *[5]Int32
var pa: *[]Int32

// implicit cast *[3]Int32 to *[]Int32
pa = &a
```


## Explicit type casting

All other kinds of type casting requires explicit type cast operator

```zig
// example: explicit cast integer values

var i: Int32
var j: Int64

i = j to Int32
j = i to Int64
```

```zig
// example: explicit cast incomplete array

var a: [10]Int32
// you can't implicit cast [3]Int -> [10]Int
// but you can do explicit cast (all rest items will be filled with zeros)
a = [1, 2, 3] to [10]Int32
```

```zig
// example: explicit cast incomplete record

type Point3D record {x: Int32, y: Int32, z: Int32}

var r: Point3D
// you can't implicit cast {x: GenericInteger} -> record {x: Int32, y: Int32, z: Int32}
// but you can do explicit cast (all rest fields will be filled with zeros)
r = {x=0} to Point3D
```
