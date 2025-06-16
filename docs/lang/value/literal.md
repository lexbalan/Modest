# Literal values

## Brief


| Literal Value Kind | Examples | Type |
| :----------: | :------: | :--: |
| Boolean Literal | `false, true` | Bool |
| Integer Literal | `0, 1, 0xF` | GenericInteger |
| Rational Literal | `0.5, 3.14, .125` | GenericFloat |
| String Literal | `"Hello!"` | GenericString |
| Array Literal | `[1, 2, 3]` | GenericArray |
| Record Literal | `{x=10, y=20}` | GenericRecord |
| Nil Literal | `nil` | Nil |

> Generic type can be implicit casted to value with [corresponded](./cast.md#Implicit-type-casting) non-generic type. 



## Integer literals
Integer literals have type [**GenericInteger**](./types.md#)
```swift
0, 1, 2, ...
```

```zig
123   // decimal number
042   // decimal number (there's not octal literals)
0x2A  // hexadecimal number
```

You can cast it to any non-generic type (Int8, Int16, Int32, Nat8, etc.)

```swift
var a: Int8
a = 42
var b: Int16
b = 42
var c: Int32
c = 42

var e: Nat8
e = 256 // error (Nat8 = {0 .. 255})
```

#### Exmples

```zig
public func main () -> Int32 {
	var x: Nat32
	x = 123
	printf("x = %i\n", x)

	var y: Nat32
	y = 042
	printf("y = %i\n", y)

	var z: Nat32
	z = 0x2A  // 0x2A == 42
	printf("z = %i\n", z)

	return 0
}
```

> Result:
`x = 123`
`y = 42`
`z = 42`



## Float literals
Float literals have type **GenericFloat**
```swift
0.25, 1.5, 3.14, etc.
```


## Bool literals
Bool literals have type **Bool**
```swift
true, false
```


## Array literals
```swift
// Array of five GenericInt values
[1, 2, 3, 4, 5]

// Array of tree Int32 values
[Int32 1, Int32 2, Int32 3]
```


### String literals

```zig
"Hello World!"
```


#### Exmples

Creating three variables with type *Array of Char* from string literal

```zig
const literalString = "I am a string literal"

var str_array8: []Char8 = literalString
var str_array16: []Char16 = literalString
var str_array32: []Char32 = literalString

var char8: Char8 = "A"
var char16: Char16 = "A"
var char32: Char32 = "A"
```

Creating three variables with type *Pointer to Array of Char* from string literal

```zig
const literalString = "I am a string literal"

var ptr_to_str8: *[]Char8 = literalString
var ptr_to_str16: *[]Char16 = literalString
var ptr_to_str32: *[]Char32 = literalString
```

Or (the same):

```zig
const literalString = "I am a string literal"

var ptr_to_str8: *Str8 = literalString
var ptr_to_str16: *Str16 = literalString
var ptr_to_str32: *Str32 = literalString
```

```zig
import "libc/stdio"

public func main () -> Int32 {
	// creating local variable with type *[]Char8 (aka *Str8)
	var string: *Str8

	// implicit cast string literal
	// (GenericArray of GenericChar) to *Str8
	string = "Hello World!"

	// print string via printf
	printf("string = \"%s\"\n", string)

	return 0
}

```
> Result: `s = "Hello World!"`



## Record literals
```swift
// Record with two fields
// 'x' with type GenericInt and value 10
// 'y' with type GenericInt and value 20
{x = 10, y = 20}
```

