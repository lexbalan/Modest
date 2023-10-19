# Types


## Type Classes

```
logical     // supports '==', '!=', 'or', 'and', 'xor', 'not'
comparable  // supports  '==', '!='
ordered     // supports '<', '>', '<=', '>='
numeric     // supports '+', '-', '*', '/', '%', 'or', 'and', 'xor', 'not'
```


## Generic types

Generic type - compile time type, that must be *implicit* casted to real types for using in runtime.

1) **GenericInteger** - type of any integral literal: `0, 1, 2, ...`
2) **GenericFloat** - type of any floating point literal: `0.5, 2.7, 3.14, ...`
3) **GenericChar** - type of any char literal: `"a"[0], "b"[0], ...`
4) **GenericArray** - type of any array literal: `[1, 2, 3], ...`
4) **GenericRecord** - type of any record literal: `{x=1, y=2, z=3}, ...`


## Real types


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
*Bool* type is logical type with only two values `true` & `false`.
Result of `==, !=, <, >, <=, >=` operations have *Bool* type.
There is two built-in values with bool type: *true* and *false*

> Classes: logical

*Usage example:*

```javascript
var b: Bool
b := false
while not b {
    b := check_condition()
}
```


#### Integer types

> Classes: numeric, comparable, ordered

Signed integer types
```javascript
Int8, Int16, Int32, Int64, Int128
```

Unsigned integer types
```javascript
Nat8, Nat16, Nat32, Nat64, Nat128
```


#### Float types

> Classes: numeric, comparable, ordered

Float types
```javascript
Float32, Float64, Float128
```


#### Char type

> Classes: comparable

Char types
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
    a[i]: = i * 10
    i := i + 1
}

// print array in cycle
i := 0
while i < 5 {
    a[i] := i * 10
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
`p.x = 1`
`p.y = 2`





