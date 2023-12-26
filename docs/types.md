# Types


### Operations


| Op Class  | Operations |
| :---: | -------- |
| `equ` | `==, !=` |
| `ord` | `<, >, <=, >=` |
| `log` | `or, and, xor, not` |
| `math` | `+, -, *, /` |
| `rem` | `%` |


## Generic types

*Generic type* - compile time type, that can be *implicit* casted to real types for using in runtime.

| GenericType | Description | Examples |
| ----------- | ----------- | -------- |
| `GenericInteger` | type of integer literal | `0, 1, 2, ...` |
| `GenericFloat` | type of floating point literal | `0.5, 2.7, 3.14, ...` |
| `GenericChar` | type of char literal | `"a"[0], "b"[0], ...` |
| `GenericArray` | type of array literal | `[1, 2, 3], ...` |
| `GenericRecord` | type of record literal | `{x=1, y=2, z=3}, ...` |


## Real *(non-generic)* types

| Type     |Size | Classes | Description |
| :------: | :-: | ------- | --- |
| `Unit`   | `0` | `-`     | `Empty type` |
| `Bool`   | `1` | `logical, equ` | |
| `Char8`  | `1` | `equ` | `UTF-8 character` |
| `Char16` | `2` | `equ` | `UTF-16 character` |
| `Char16` | `4` | `equ` | `UTF-32 character` |
| `Int8`   | `1` | `equ, ord, math, rem` | `signed` |
| `Int16`  | `2` | `equ, ord, math, rem` | `signed` |
| `Int32`  | `4` | `equ, ord, math, rem` | `signed` |
| `Int64`  | `8` | `equ, ord, math, rem` | `signed` |
| `Int128` | `16` | `equ, ord, math, rem` | `signed` |
| `Nat8`   | `1` | `equ, ord, math, rem` | `unsigned` |
| `Nat16`  | `2` | `equ, ord, math, rem` | `unsigned` |
| `Nat32`  | `4` | `equ, ord, math, rem` | `unsigned` |
| `Nat64`  | `8` | `equ, ord, math, rem` | `unsigned` |
| `Nat128` | `16` | `equ, ord, math, rem` | `unsigned` |
| `Float32`  | `4` | `equ, ord, math` | `floating point` |
| `Float64`  | `8` | `equ, ord, math` | `floating point` |


> Alignment of any base type is equal to his size, **exclude the *Unit* type**.


#### Examples

#### Unit type
*Unit* type is an analog of `void` type in C language.
It used to indicate that function have no return value
```swift
func no_return_func () -> Unit {
}
```
Also, you can construct *Unit* value from not used function parameter to prevent error message:
```swift
func just (not_used_param: Int32) -> Unit {
    not_used_param to Unit
}
```


#### Bool type

```javascript
var b: Bool

b := false

while not b {
    b := check_condition()
}

```


#### Integer types

##### Signed integer types
```javascript
Int8, Int16, Int32, Int64, Int128
```

```rust
func main () -> Unit {
	var a, b : Int32
	
	a := -1
	b := 1
	
	if a < b {
		printf("a < b\n")
	} else if a > b {
		printf("a > b\n")
	} else {
		printf("a == b\n")
	}
}
```
> Result: `a < b`


##### Unsigned integer types
```javascript
Nat8, Nat16, Nat32, Nat64, Nat128
```

```rust
func main () -> Unit {
	var a, b : Nat32
	
	a := -1 to Nat32
	b := 1
	
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



#### Float types

Float types
```javascript
Float32, Float64
```

```rust
import "libc/stdio.hm"
import "libc/math.hm"

func main () -> Unit {
	var pi: Float64
	
	pi := M_PI

	printf("pi = %lf\n", pi)
}

```
> Result: `pi = 3.14....`

#### Char type

> Classes: *equ*

There is three char types
```javascript
Char8, Char16, Char32
```

*Usage example:*

```rust
var a : Char8
var b : Char8

a := "a"[0]
b := "b"[0]

if a == b {
    printf("'a' == 'b'\n")
} else {
    printf("'a' != 'b'\n")
}
```

> Result: `'a' != 'b'`



#### Array types
There is *defined* arrays:
```javascript
[10]Int32  // array with ten Int32 elements
[16]Char8  // array with sixteen Char8 elements
...
```
And *undefined* arrays:
```javascript
[]Int32  // array with unknown amount of Int32 elements
[]Char8  // array with unknown amount of Char8 elements
...
```
You can't create variable of undefined array, but you can create pointer to it
```javascript
// creating two variables with type
var a: *[]Int32  // pointer to undefined array of Int32
var s: *[]Char8  // pointer to undefined array of Char8
...
```

*Usage example:*
```rust

var a : [5]Int32

var i : Int32

// fill array in cycle
i := 0
while i < 5 {
    a[i] := i * 10
    i := i + 1
}

// print array in cycle
i := 0
while i < 5 {
    printf("a[%d] = %d\n", i, a[i])
    i := i + 1
}

```

> Result:
`a[0] = 0`
`a[1] = 10`
`a[2] = 20`
`a[3] = 30`
`a[4] = 40`



Function parameter cannot be an array. But it can be a pointer to array.



###### String types
String types are builtin aliases of `[]Char8`, `[]Char16`, `[]Char32`
```rust
// (Built-in types!)
type Str8 = []Char8
type Str16 = []Char16
type Str32 = []Char32
```

*Usage example:*
```rust
var s : *Str8

s := "Hello World!\n"

printf(s)
```

> Result: `Hello World!`



#### Record types
Record type is a composite type, that can contain inside values of any *another* type.
```javascript
record {x: Float64, y: Float64}
```

*Usage example:*
```rust
// it is good idea to use type definition statement
// for bind identifier to record type  
type Point record {
    x : Float64
    y : Float64
}

var p : Point

p := {x=1, y=2}

printf("p.x = %f\n", p.x)
printf("p.y = %f\n", p.y)
```

> Result:
`p.x = 1.0`
`p.y = 2.0`





