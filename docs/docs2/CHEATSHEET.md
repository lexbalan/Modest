# Modest Language Cheat Sheet

Quick reference for writing Modest code.

## Types

> Type identifiers always starts from Big letter
Variable, Constant & Function identifiers starts from small letter
Language style use PascalCase for types and camelCase for all another entities

> Instead type cast there is value construction operation `Int 5`, `[4]Int32 [1, 2, 3, 4]`, etc.

> Pointers not works like arrays in C, for index need pointer to array `*[]Type`


### Base Types
```modest
Integer                            // builtin compile-time type for integer literals, can be implicitly casted to IntX, NatX, WordX, FloatX
Rational                           // builtin compile-time type for rational literals, can be implicitly casted to FloatX
Unit                               // void (empty type)
Bool                               // true, false
Int8, Int16, Int32, Int64          // signed integers
Nat8, Nat16, Nat32, Nat64          // unsigned integers
Word8, Word16, Word32, Word64      // bitwise operations
Char8, Char16, Char32              // characters
Float32, Float64                   // floating point
Str8, Str16, Str32                 // aliases for: *[]Char8, *[]Char16, *[]Char32
```

### Composite Types
```modest
[N]Type                            // fixed array: [10]Int32
[N][M]Type                         // multi-dimensional: [2][3]Int32
[]Type                             // array with unknown length - it must be infered at compile time (sugar)
*Type                              // pointer: *Int32, **Int32
*Unit                              // generic pointer (any type)
{field1: Type1, field2: Type2}     // anonymous record
type Name = Type                   // type alias
type Name = {f1: T1, f2: T2}       // named record
type Name = @branded Type          // branded type (newtype)
() -> Unit                         // function without params & return value
(a: Int32, b: Int32) -> Int32      // function with two params & a return value
```

> There is no way to create field with function type, but you can create pointer to function

## Literals
```modest
42, 0xFF                           // integers (only decimal & hexadecimal)
3.14, 0.5                          // floats
true, false                        // bool
"Hello World"                      // string literal (no dedicated char literal)
[1, 2, 3]                          // array
{x = 10, y = 20}                   // record
nil                                // null pointer
```

## Definitions

### Functions
```modest
func add (a: Int32, b: Int32) -> Int32 {
    return a + b
}

func main () -> Int32 {
    return 0
}

func no_return () -> Unit {
    printf("hello\n")
}
```

### Variables & Constants
```modest
var x: Int32                       // zero-initialized ()
var x: Int32 = 10                  // with value
var x = 10                         // type inferred
var x, y, z: Int32                 // multiple

const max = 100                    // module-level constant
const pi: Float64 = 3.14159

let local = 42                     // immutable local (only in functions)
```

### Types
```modest
type Point = {x: Float64, y: Float64}
type IntPtr = *Int32
type StringPtr = *Char8
type Meters = @branded Float64        // newtype
type Packed = @packed {a: Bool, b: Int32}
type Volatile = @volatile Word32
```

## Statements

### If/Else
```modest
if condition {
    // ...
} else if condition2 {
    // ...
} else {
    // ...
}
```

### While Loop
```modest
while condition {
    // ...
    break                          // exit
    again                          // continue
}
```

### Assignment
```modest
x = 10
arr[i] = value
arr1[1:4] = [1, 2, 3]
ptr.field = 5
*ptr = 100
```

### Return
```modest
return value
return                             // for Unit
```

### Block
```modest
{
    var local: Int32 = 10
    // local scope
}
```

### Increment/Decrement
```modest
++i  // it's just statement
--j  // only prefix form
```


## Operators

### Arithmetic
```modest
a + b, a - b, a * b, a / b, a % b
-a                                 // negation
```

### Comparison
```modest
a == b, a != b
a < b, a > b, a <= b, a >= b
```

### Logical
```modest
a and b
a or b
not a
```

### Unary
```modest
&x                                 // address of
*ptr                               // dereference
-x                                 // negation
not x                              // logical not
sizeof(Type/value)                 // size in bytes
alignof(Type/value)                // alignment
lengthof(ArrayType/arrayValue)     // array length
offsetof(RecordType.field)         // field offset
```

### Access
```modest
arr[i]                             // index (returns an element)
arr[i:j]                           // slice (returns sub array)
record.field                       // field access
ptr.field                          // auto-deref field
func(args)                         // function call
```

## Value Construction

```modest
Int32 10                           // explicit type
Float64 3.14
*Int32 &x
Point {x = 1, y = 2}
```

## Access Modifiers

```modest
func foo () -> Unit { }            // private (default)
func main () -> Int32 { }   // public
```

## Examples

### Hello World
```modest
import "libc/stdio"

func main () -> Int32 {
    printf("Hello World!\n")
    return 0
}
```

### Function with Loop
```modest
func sum (n: Int32) -> Int32 {
    var total: Int32 = 0
    var i: Int32 = 0

    while i < n {
        total = total + i
        i = i + 1
    }

    return total
}
```

### Record (Struct)
```modest
type Person = {
    name: *[]Char8
    age: Int32
}

func print_person (p: Person) -> Unit {
    printf("Name: %s, Age: %d\n", p.name, p.age)
}

let alice: Person = {name = "Alice", age = 30}
print_person(alice)
```

### Pointers
```modest
var x: Int32 = 100
var ptr: *Int32 = &x
var val = *ptr                     // 100

*ptr = 200                         // x is now 200
```

### Arrays
```modest
var arr: [5]Int32 = [1, 2, 3, 4, 5]
var first = arr[0]                 // 1
var slice = arr[1..3]              // [2, 3]

var i: Int32 = 0
while i < 5 {
    printf("%d\n", arr[i])
    i = i + 1
}
```

### Conditional
```modest
var age: Int32 = 25

if age >= 18 {
    printf("adult\n")
} else if age >= 13 {
    printf("teenager\n")
} else {
    printf("child\n")
}
```

### Dynamic Array (String)
```modest
var msg: *Char8 = "Hello"
var first_char = msg[0]            // 'H'

func print_string (s: *Char8) -> Unit {
    printf("%s\n", s)
}

print_string("Modest Language")
```

## Key Differences from C

| Feature | C | Modest |
|---------|---|--------|
| Function signature | `int add(int a, int b)` | `func add (a: Int32, b: Int32) -> Int32` |
| Variable decl | `int x = 10;` | `var x: Int32 = 10` |
| Pointer deref | `*ptr` | `*ptr` (same) |
| Address of | `&var` | `&var` (same) |
| Arrays | `int arr[10]` | `var arr: [10]Int32` |
| Struct | `struct Point { int x; int y; }` | `type Point = {x: Int32, y: Int32}` |
| Return type | `int func()` | `func name () -> Int32` |
| No return | `void func()` | `func name () -> Unit` |
| Type system | Implicit/weak | Strict, explicit |

## Compilation

```bash
mcc source.m              # compile to C
mcc -backend llvm source.m # compile to LLVM
mcc -backend modest source.m # compile to Modest
```

## Common Imports

```modest
import "libc/stdio"       // printf, scanf
import "libc/stdlib"      // malloc, free
import "libc/string"      // strcpy, strlen
import "libc/math"        // sin, cos, sqrt, etc.
```
