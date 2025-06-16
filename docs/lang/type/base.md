# Base types

| Type	 | Size (in bytes) | Classes | Description |
| :------: | :-: | ------- | --- |
| `Unit`   | `0` | `-` | `Empty type (void in C)` |
| `Bool`   | `1` | `equ, logical` | `8-bit` |
| `Word8`  | `1` | `equ, logical` | `8-bit word` |
| `Word16` | `2` | `equ, logical` | `16-bit word` |
| `Word32` | `4` | `equ, logical` | `32-bit word` |
| `Word64` | `8` | `equ, logical` | `64-bit word` |
| `Word128` | `16` | `equ, logical` | `128-bit word` |
| `Int8`   | `1` | `equ, ord, math, rem` | `signed integer 8-bit` |
| `Int16`  | `2` | `equ, ord, math, rem` | `signed integer 16-bit` |
| `Int32`  | `4` | `equ, ord, math, rem` | `signed integer 32-bit` |
| `Int64`  | `8` | `equ, ord, math, rem` | `signed integer 64-bit` |
| `Int128` | `16` | `equ, ord, math, rem` | `signed integer 128-bit` |
| `Nat8`   | `1` | `equ, ord, math, rem` | `unsigned integer 8-bit` |
| `Nat16`  | `2` | `equ, ord, math, rem` | `unsigned integer 16-bit` |
| `Nat32`  | `4` | `equ, ord, math, rem` | `unsigned integer 32-bit` |
| `Nat64`  | `8` | `equ, ord, math, rem` | `unsigned integer 64-bit` |
| `Nat128` | `16` | `equ, ord, math, rem` | `unsigned integer 128-bit` |
| `Char8`  | `1` | `equ` | `for 8-bit character` |
| `Char16` | `2` | `equ` | `for 16-bit character` |
| `Char32` | `4` | `equ` | `for 32-bit character` |
| `Float32` | `4` | `equ, ord, math` | `floating point 32-bit` |
| `Float64` | `8` | `equ, ord, math` | `floating point 64-bit` |


> Alignment of any base type is equal to his size, **exclude the *Unit* type (alignof(Unit) = 1)**.


#### Operation classes


| Op Class  | Operations | Comment |
| :---: | -------- | ------ |
| `equ` | `==, !=` | equivalence operations |
| `ord` | `<, >, <=, >=` | order operations |
| `log` | `or, and, xor, not` | logical operations |
| `math` | `+, -, *, /` | mathmatical operations |
| `rem` | `%` | remainder of integer division operation |




### Unit type
*Unit* type is an analog of `void` type in C language.
It used to indicate that function have no return value
```swift
func no_return_func () -> Unit {
	// this function returns nothing
}
```

Also, you can construct *Unit* value from not used function parameter to prevent *warning(unused value)* compiler message:
```swift
func just (not_used_param: Int32) -> Unit {
	Unit not_used_param
}
```

Unit type obtain another sense in context of *Pointer to Unit*. This type also
called as [*FreePointer*](#Free-pointer-type).


### Bool type

```zig
var b: Bool

b = false

while not b {
	b = check_condition()
}

```


### Word type
```zig
Word8, Word16, Word32, Word64, Word128
```
Word type is unsigned integer type that allows bitwise operations.
```zig
public func main () -> Int32 {
	var byte: Word8

	// GenericInteger will be implicit casted to Word8
	byte = 42

	printf("byte = %i", Nat32 byte)

	return 0
}
```


### Integer type

#### Signed integer type
```zig
Int8, Int16, Int32, Int64, Int128
```

```zig
public func main () -> Unit {
	var a, b: Int32

	a = -1
	b = 1

	if a < b {
		printf("a < b\n")
	} else if a > b {
		printf("a > b\n")
	} else {
		printf("a == b\n")
	}
}
```
*Result:*
> `a < b`


#### Unsigned integer type
```zig
Nat8, Nat16, Nat32, Nat64, Nat128
```

```zig
public func main () -> Unit {
	var a, b: Nat32

	a = Nat32 -1
	b = 1

	if a < b {
		printf("a < b\n")
	} else if a > b {
		printf("a > b\n")
	} else {
		printf("a == b\n")
	}
}
```
> Result: `a > b`



### Float type

Float types
```zig
Float32, Float64
```

```zig
import "libc/stdio"
import "libc/math"

public func main () -> Unit {
	var pi: Float64

	pi = M_PI

	printf("pi = %lf\n", pi)
}

```
*Result:*
> `pi = 3.14....`

### Char type

> Classes: *equ*

There is three char types
```zig
Char8, Char16, Char32
```

*Usage example:*

```zig
var a: Char8
var b: Char8

a = "a"[0]
b = "b"[0]

if a == b {
	printf("'a' == 'b'\n")
} else {
	printf("'a' != 'b'\n")
}
```
*Result:*
> `'a' != 'b'`



### Array type
There is *defined* arrays:
```zig
[10]Int32  // array with ten Int32 elements
[16]Char8  // array with sixteen Char8 elements
...
```
And *undefined* arrays:
```zig
[]Int32  // array with unknown amount of Int32 elements
[]Char8  // array with unknown amount of Char8 elements
...
```
You can't create variable of undefined array, but you can create pointer to it
```zig
// creating two variables with type
var a: *[]Int32  // pointer to undefined array of Int32
var s: *[]Char8  // pointer to undefined array of Char8
...
```

*Usage example:*
```zig

var a: [5]Int32

var i: Int32

// fill array in cycle
i = 0
while i < 5 {
	a[i] = i * 10
	i = i + 1
}

// print array in cycle
i = 0
while i < 5 {
	printf("a[%d] = %d\n", i, a[i])
	i = i + 1
}

```

*Result:*
> `a[0] = 0`<br/>
> `a[1] = 10`<br/>
> `a[2] = 20`<br/>
> `a[3] = 30`<br/>
> `a[4] = 40`<br/>



Function parameter cannot be an array. But it can be a pointer to array.



#### String type
String types are builtin aliases for `[]Char8`, `[]Char16`, `[]Char32`
String literal is an alternative form of Char array recording.
```zig
// (!) implicit defined built-in types
type Str8 = []Char8
type Str16 = []Char16
type Str32 = []Char32
```

*Usage example:*
```zig
var s: *Str8

s = "Hello World!\n"

printf(s)
```
*Result:*
> `Hello World!`



### Record type
Record type is a composite type, that can contain inside values of any *another* type.
```zig
record {x: Float64, y: Float64}
```

*Usage example:*
```zig
// it is good idea to use type definition statement
// for bind identifier to record type
type Point = record {
	x: Float64
	y: Float64
}

var p: Point

p = {x=1, y=2}

printf("p.x = %f\n", p.x)
printf("p.y = %f\n", p.y)
```

*Result:*
> `p.x = 1.0`<br/>
> `p.y = 2.0`<br/>



### Pointer type


#### Free pointer type
*Pointer to Unit* (aka *Free pointer type*) can points to value of **any type**.
```swift
// see: test/free_pointer/src/main.m

import "libc/stdio"

public func main () -> Int32 {
	var a: Bool
	var b: Int32
	var c: Int64

	//
	var freePointer: *Unit

	// free pointer can points to value of any type
	freePointer = &a  // it's ok (just for demonstration)
	freePointer = &b  // it's also ok
	freePointer = &c  // after all it will be points to value c (with type Int64)

	// you can't do dereference operation with Free pointer
	// (because runtime doesn't have any idea about value type it pointee),
	// but you can construct another (non Free) pointer from it
	// and use it as usualy
	*(*Int64 freePointer) = 123456789123456789

	printf("c = 0x%llX\n", c)

	// Let's create new pointer to *Int64 from freePointer
	let px = *Int64 freePointer

	// And will use it...
	let x = *px

	// for pointer mechanics checking
	printf("x = 0x%llX\n", x)

	return 0
}
```
*Result:*
> `c = 0x123456789ABCDEF`<br/>
> `x = 0x123456789ABCDEF`<br/>




