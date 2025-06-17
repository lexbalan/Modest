# Generic types

*Generic type* - compile time type, that can be *implicitly* casted to *Non-Generic types* for using in runtime.


| GenericType | Represented Value | Examples |
| ----------- | ----------- | -------- |
| `GenericInteger` | integer literal | `0, 1, 2, ...` |
| `GenericFloat` | floating point literal | `0.5, 2.7, 3.14, ...` |
| `GenericChar` | char value expression | `"a"[0], "b"[0], ...` |
| `GenericArray` | array value expression | `[1, 2, 3], [1], ...` |
| `GenericRecord` | record value expression | `{x=1, y=2, z=3}, {a=10, b=20}, ...` |


## Generic Integer

*Generic integer* value can be implicitly casted to *Integer*, *Float* and *Word8* types, and explicitly to *Unit* and *Char*.


#### Example
```swift
public func main () -> Int {
	// Any integer literal have GenericInteger type
	let one = 1

	// result of such expressions also have generic type
	let two = 1 + one

	// GenericInteger value can be implicitly casted to any Integer type
	var a: Int32 = one  // implicit cast GenericInteger value to Int32
	var b: Nat64 = one  // implicit cast GenericInteger value to INat64
	...

	// to Float
	var f: Float32 = one  // implicit cast GenericInteger value to Float32
	var g: Float64 = one  // implicit cast GenericInteger value to Float64

	// and to Word8
	var x: Word8 = one  // implicit cast GenericInteger value to Word8


	// explicit cast GenericInteger value

	var c: Char8 = Char8 one	// explicit cast GenericInteger value to Char8
	var d: Char16 = Char16 one  // explicit cast GenericInteger value to Char16
	var e: Char32 = Char32 one  // explicit cast GenericInteger value to Char32

	var k: Bool = one != 0  // (!) 'explicit cast' GenericInteger value to Bool

	return 0
}

```

## Generic Float

*Generic float* value can be implicitly casted to *Float* type, and explicitly to *Unit* and *Integer*.

#### Example
```swift
public func main () -> Int {
	// Any float literal have GenericFloat type
	let pi = 3.141592653589793238462643383279502884

	// value with GenericFloat type
	// can be implicit casted to any Float type
	// (in this case value may lose precision)
	var f: Float32 = pi  // implicit cast GenericFloat value to Float32
	var g: Float64 = pi  // implicit cast GenericFloat value to Float64

	// explicit cast GenericFloat value to Int32
	var x: Int32 = Int32 pi

	return 0
}

```


## Generic Char

*Generic char* value can be implicitly casted to *Char* type, and explicitly to *Unit* and *Integer*. In compiler generic char have 32-bit representation.

#### Example
```swift
public func main () -> Int {
	// Any char value expression have GenericChar type
	// (you can pick GenericChar value by index of GenericString value)
	let a = "A"[0]

	// value with GenericChar type
	// can be implicit casted to any Char type
	var b: Char8 = a   // implicit cast GenericChar value to Char8
	var c: Char16 = a  // implicit cast GenericChar value to Char16
	var d: Char32 = a  // implicit cast GenericChar value to Char32

	// explicit cast GenericChar value to Int32
	var char_code: Int32 = Int32 a

	return 0
}

```

## Generic Array
*Generic array* value can be implicitly casted to *Array* with compatible type and same size. Explicitly it can be casted to Array with compatible type and bigger (or equal) size.

> Only exception - *empty array* value - it can be implicitly casted to any array

#### Example
```swift
public func main () -> Int {
	// Any array expression have GenericArray type
	// this array expression (GenericArray of four GenericInteger items)
	let a = [0, 1, 2, 3]

	// value with GenericArray type
	// can be implicit casted to Array with compatible type and same size

	// implicit cast Generic([4]GenericInteger) value to [4]Int32
	var b: [4]Int32
	b = a

	// implicit cast Generic([4]GenericInteger) value to [4]Nat64
	var c: [4]Int64
	c = a


	// explicit cast Generic([4]GenericInteger) value to [10]Int32
	var d: [10]Int32 = [10]Int32 a

	return 0
}

```


## Generic Record

*Generic record* value can be implicitly casted to *Record* with same fields. Explicitly it can be casted to *Record* with extra fields.

> Only exception - *empty record* value - it can be implicitly casted to any record

#### Example
```swift

type Point2D = record {
	x: Int32
	y: Int32
}

type Point3D = record {
	x: Int32
	y: Int32
	z: Int32
}

public func main () -> Int {
	// Any record expression have GenericRecord type
	// this record expression have type:
	// Generic(record {x: GenericInteger, y: GenericInteger})
	let p = {x = 10, y = 20}

	// value with GenericRecord type
	// can be implicit casted to Record with same fields. 

	// implicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	// to record {x: Int32, y: Int32}
	var point_2d: Point2D
	point_2d = p


	// explicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	// to record {x: Int32, y: Int32, z: Int32}
	var point_3d: Point3D
	point_3d = Point3D p

	return 0
}

```


