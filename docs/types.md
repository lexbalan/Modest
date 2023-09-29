# Types

## Generic types

Generic type - compile time type, that must be casted to any real type for using in runtime.

1) GenericInteger - type of any integral literal (0, 1, 2, ...)
2) GenericFloat - type of any floating point literal (0.5, 2.7, 3.14, ...)
3) GenericString - type of string literal ("Hello world!\n", "hi!", ...)


## Real types


### Unit type
Unit type is an analog of *void* type in C language.
It used to indicate that function have no return value
```
func no_return_func () -> Unit {
}
```


### Bool type
Bool type is logical type with only two values true & false.
Result of [==, !=, <, >, <=, >=] operations have Bool type.



### Integer types

Signed integer types
```
Int8, Int16, Int32, Int64, Int128
```

Unsigned integer types
```
Nat8, Nat16, Nat32, Nat64, Nat128
```


### Float types
Float types
```
Float32, Float64, Float128
```


### Char type
There's no special char type, instead use Nat8, Nat16 or Nat32 integer type



### String types
String types are builtin pointers to arrays of Nat8, Nat16, Nat32
```
Str8, Str16, Str32
```


