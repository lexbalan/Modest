# Types


## Type Classes

```
generic     // it's a generic type
logical     // supports '==', '!=', 'or', 'and', 'xor', 'not'
comparable  // supports  '==' & '!='
ordered     // supports '<', '>', '<=', '>='
numeric     // supports '+', '-', '*', '/', '%', 'or', 'and', 'xor', 'not'
```


## Generic types

Generic type - compile time type, that must be *implicit* casted to real types for using in runtime.

1) GenericInteger - type of any integral literal: 0, 1, 2, ...
2) GenericFloat - type of any floating point literal: 0.5, 2.7, 3.14, ...
3) GenericChar - type of any char literal: "a"[0], "b"[0], ...
4) GenericArray - type of any array literal: [1, 2, 3], ...
4) GenericRecord - type of any array literal: {x=1, y=2, z=3}, ...


## Real types


### Unit type
Unit type is an analog of *void* type in C language.
It used to indicate that function have no return value
```swift
func no_return_func () -> Unit {
}
```


### Bool type
Bool type is logical type with only two values true & false.
Result of [==, !=, <, >, <=, >=] operations have Bool type.
There is two built-in values with bool type: *true* and *false*
```javascript
var b: Bool
b := false
while not b {
    b := check_condition()
}
```


### Integer types

Signed integer types
```javascript
Int8, Int16, Int32, Int64, Int128
```

Unsigned integer types
```javascript
Nat8, Nat16, Nat32, Nat64, Nat128
```


### Float types
Float types
```javascript
Float32, Float64, Float128
```


### Char type
Char types
```javascript
Char8, Char16, Char32
```


### Array types
There is *defined* arrays:
```javascript
[10]Int32  // array with ten elements of Int32
[16]Char8  // array with sixteen elements of Char8
```
And *undefined* arrays:
```javascript
[]Int32  // array with unknown amount elements of Int32
[]Char8  // array with unknown amount elements of Char8
```
You can't create variable of undefined array, but you can create pointer to it
```javascript
// creating two variables
// with type pointer to undefined array
var a: *[]Int32
var s: *[]Char8
```

#### String types
String types are builtin aliases of *[]Char8*, *[]Char16*, *[]Char32*
```rust
type Str8 = []Char8
type Str16 = []Char16
type Str32 = []Char32
```



### Record types
Record type is a composite type, that can contain inside values of any *another* type.
```javascript
record {x: Float64, y: Float64}
```





