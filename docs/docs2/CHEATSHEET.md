# Modest Language Cheat Sheet

Quick reference for writing Modest code.

## Types

> Type identifiers always start with a capital letter.
> Variables, constants and function identifiers use camelCase.
> Language style: PascalCase for types, camelCase for everything else.

> Instead of type cast there is a value construction operation: `Int32 5`, `[4]Int32 [1, 2, 3, 4]`, etc.

> Pointers do not work like arrays in C — to index through a pointer you need a pointer to array `*[]Type`.


### Base Types
```modest
Integer                            // compile-time type for integer literals — implicitly cast to IntX, NatX, WordX, FloatX
Rational                           // compile-time type for rational literals — implicitly cast to FloatX
Unit                               // void (empty type)
Bool                               // true, false
Int8, Int16, Int32, Int64          // signed integers
Nat8, Nat16, Nat32, Nat64          // unsigned integers
Word8, Word16, Word32, Word64      // bitwise integers
Char8, Char16, Char32              // characters
Float32, Float64                   // floating point
Str8, Str16, Str32                 // aliases for: *[]Char8, *[]Char16, *[]Char32
```

### Compile-time (Generic) Types

Literals have a *compile-time type* that is resolved to a concrete type at use site.
These are sometimes called **generic** types internally.

| Compile-time type  | Literal form              | Implicitly converts to          |
|--------------------|---------------------------|---------------------------------|
| `Integer`          | `0`, `42`, `0xFF`         | IntX, NatX, WordX, Float, Char  |
| `Rational`         | `3.14`, `0.5`             | FloatX                          |
| `GenericChar`      | `"A"[0]`                  | CharX                           |
| `GenericArray`     | `[1, 2, 3]`               | same-size array of matching type|
| `GenericRecord`    | `{x=1, y=2}`              | record with same fields         |

```modest
let n = 42             // type is Integer (compile-time), not Int32
var i: Int32 = n       // Integer implicitly cast to Int32
var f: Float64 = n     // Integer implicitly cast to Float64

let pi = 3.14          // type is Rational
var g: Float32 = pi    // Rational implicitly cast to Float32
```

### Composite Types
```modest
[N]Type                            // fixed array: [10]Int32
[N][M]Type                         // multi-dimensional: [2][3]Int32
[]Type                             // unsized array (compile-time only, always behind pointer)
*Type                              // pointer: *Int32, **Int32
*Unit                              // untyped pointer (any type)
{field1: Type1, field2: Type2}     // anonymous record
type Name = Type                   // type alias
type Name = {f1: T1, f2: T2}       // named record
type Name = @branded Type          // branded type (newtype pattern)
() -> Unit                         // function type: no params, no return
(a: Int32, b: Int32) -> Int32      // function type: two params, return value
*() -> Unit                        // pointer to function
```

> There is no field with a function type — use a pointer to function instead.


## Literals
```modest
42, 0xFF                           // integers (decimal and hexadecimal)
3.14, 0.5                          // floats
true, false                        // bool
"Hello World"                      // string literal
'Hello World'                      // string literal (no dedicated char literal)
[1, 2, 3]                          // array literal
{x = 10, y = 20}                   // record literal
nil                                // null pointer
```

## Definitions

### Functions
```modest
func add (a: Int32, b: Int32) -> Int32 {
    return a + b
}

func main () -> Int {
    return 0
}

func no_return () -> Unit {
    printf("hello\n")
}
```

### Variables & Constants
```modest
var x: Int32                       // global is zero-initialized, local - undefined
var x: Int32 = 10                  // with initial value
var x = 10                         // type inferred from value
var x, y, z: Int32                 // multiple vars of same type

const max = 100                    // module-level constant (type inferred)
const pi: Float64 = 3.14159        // with explicit type

let local = 42                     // immutable binding — only inside functions
```

> `let` is only allowed inside function bodies. For module-level values use `var` or `const`.

### Types
```modest
type Point = {x: Float64, y: Float64}
type IntPtr = *Int32
type CStr = *Char8
type Meters = @branded Float64        // newtype (incompatible with Float64)
type Packed = @layout("packed") {a: Bool, b: Int32}
type Volatile = @volatile Word32
```

## Modules

### include vs import

```modest
include "libc/stdio"     // paste module into current namespace (no prefix)
                         // used for C bindings and lib modules

import "mymodule"        // import with namespace prefix
                         // used for your own Modest source modules
```

```modest
// with include — use names directly:
include "libc/stdio"
printf("hello\n")

// with import — use module prefix:
import "utils"
utils.doSomething()
```

### Common includes
```modest
include "libc/ctypes64"   // Int32, Nat32, Float64, etc. (type aliases)
include "libc/stdio"      // printf, scanf, fopen, fclose
include "libc/stdlib"     // malloc, free, exit
include "libc/string"     // strcpy, strlen, memcpy
include "libc/math"       // sin, cos, sqrt, pow
include "libc/socket"     // socket, bind, connect, send, recv
include "libc/unistd"     // read, write, close
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
    break                          // exit loop
    again                          // continue (next iteration)
}
```

### Assignment
```modest
x = 10
arr[i] = value
arr[1:4] = [1, 2, 3]              // slice assignment
ptr.field = 5                     // auto-deref field write
*ptr = 100                        // dereference write
```

### Return
```modest
return value
return                             // for Unit functions
```

### Block
```modest
{
    var local: Int32 = 10
    // scoped to this block
}
```

### Increment/Decrement
```modest
++i   // prefix only — it is a statement, not an expression
--j
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

### Unary / Special
```modest
&x                                 // address of
*ptr                               // dereference
sizeof(Type)  sizeof(value)        // size in bytes
alignof(Type) alignof(value)       // alignment in bytes
lengthof(ArrayType)                // number of elements in array type
offsetof(RecordType.field)         // byte offset of field
```

### Access
```modest
arr[i]                             // index (element)
arr[i:j]                           // slice (sub-array)
record.field                       // field access
ptr.field                          // auto-deref field access (no -> needed)
func(args)                         // call
```

## Value Construction

Explicit type construction (not a cast — creates a new value):
```modest
Int32 10                           // integer literal → Int32
Float64 3.14                       // rational literal → Float64
Nat8 0xFF                          // integer literal → Nat8
*Int32 ptr                         // pointer reinterpretation (unsafe)
Point {x = 1, y = 2}               // record construction
[4]Int32 [1, 2, 3]                 // explicit array (fills remaining with 0)
Unit value                         // discard a value (suppress warnings)
```

## Annotations

```modest
@inline                            // suggest inlining to backend
@extern                            // external symbol (C linkage)
@alias("c_name")                   // maps to a different C symbol name
@c_include("header.h")             // emit #include in C output
@branded                           // newtype wrapper (nominal typing)
@packed                            // packed struct (no padding)
@volatile                          // volatile memory
```

```modest
@inline
func min (a: Int32, b: Int32) -> Int32 {
    if a < b { return a }
    return b
}

@extern @alias("malloc")
func my_alloc (size: Nat64) -> *Unit

@c_include("sys/types.h")
type MyHandle = Int32
```


## Examples

### Hello World
```modest
include "libc/ctypes64"
include "libc/stdio"

func main () -> Int {
    printf("Hello World!\n")
    return 0
}
```

### Working with Records
```modest
include "libc/ctypes64"
include "libc/math"
include "libc/stdio"

type Point = {
    x: Float
    y: Float
}

@inline
func distance (a: Point, b: Point) -> Float {
    let dx = a.x - b.x
    let dy = a.y - b.y
    return sqrt(dx*dx + dy*dy)
}

func main () -> Int {
    let a = Point {x = 0.0, y = 0.0}
    let b = Point {x = 3.0, y = 4.0}
    printf("distance = %f\n", distance(a, b))
    return 0
}
```

### Pointer to Record
```modest
include "libc/ctypes64"
include "libc/stdlib"
include "libc/stdio"

type Node = {
    value: Int32
    next:  *Node
}

func main () -> Int {
    let n = *Node malloc(sizeof(Node))
    n.value = 42
    n.next = nil
    printf("value = %d\n", n.value)
    free(n)
    return 0
}
```

### Arrays
```modest
var arr: [5]Int32 = [1, 2, 3, 4, 5]
var first = arr[0]                 // 1
var slice = arr[1:3]               // sub-array [2, 3]

var i: Int32 = 0
while i < 5 {
    printf("%d\n", arr[i])
    ++i
}
```

### Loop with While
```modest
func sum (n: Int32) -> Int32 {
    var total: Int32 = 0
    var i: Int32 = 0
    while i < n {
        total = total + i
        ++i
    }
    return total
}
```

### Pointer to Function
```modest
type Handler = *(payload: *Unit) -> Unit

func on_event (payload: *Unit) -> Unit {
    printf("event!\n")
}

var handler: Handler = &on_event
handler(nil)
```

### Multi-source Module
```modest
// main.m
include "libc/ctypes64"
include "libc/stdio"
import "utils"

func main () -> Int {
    utils.greet()
    return 0
}

// utils.m
include "libc/stdio"

func greet () -> Unit {
    printf("hello from utils\n")
}
```


## Key Differences from C

| Feature          | C                              | Modest                                    |
|------------------|--------------------------------|-------------------------------------------|
| Function sig     | `int add(int a, int b)`        | `func add (a: Int32, b: Int32) -> Int32`  |
| Variable decl    | `int x = 10;`                  | `var x: Int32 = 10`                       |
| Struct           | `struct Point { int x; int y; }` | `type Point = {x: Int32, y: Int32}`     |
| Field via ptr    | `ptr->field`                   | `ptr.field` (auto-deref)                  |
| Arrays           | `int arr[10]`                  | `var arr: [10]Int32`                      |
| Return type      | `int func()`                   | `func name () -> Int32`                   |
| Void             | `void func()`                  | `func name () -> Unit`                    |
| Logical ops      | `&&`, `\|\|`, `!`              | `and`, `or`, `not`                        |
| Continue         | `continue`                     | `again`                                   |
| Type system      | implicit/weak                  | strict, explicit                          |
| Namespaces       | none                           | `import "mod"` → `mod.name`               |


## Compilation

```bash
mcc -o main -mbackend=c11 main.m       # translate to C (main.c)
mcc -o main -mbackend=llvm main.m      # translate to LLVM IR (main.ll)
mcc -o main -mbackend=modest main.m    # translate to Modest IR (main.cm)

mcc -o main -mbackend=c11 -fparanoid main.m   # warnings as errors
mcc -o main -mbackend=c11 -funsafe main.m     # enable unsafe pointer ops
```
