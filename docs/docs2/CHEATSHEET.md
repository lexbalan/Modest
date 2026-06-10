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
| `String`           | `"hello"`, `'hello'`      | CharX, StrX (= `*[]CharX`)      |
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

| Literal | Type | Notes |
|---------|------|-------|
| `42`, `0xFF` | `Integer` | compile-time; converts to IntX, NatX, WordX, FloatX, CharX |
| `3.14`, `0.5` | `Rational` | compile-time; converts to FloatX |
| `true`, `false` | `Bool` | | non-generic; just Bool
| `"Hello World"` | `String` | compile-time; converts to CharX or StrX (`*[]CharX`) |
| `'Hello World'` | `String` | same; no char literal — use value construction: `Char8 'A'` |
| `[1, 2, 3]` | `GenericArray` | compile-time; converts to same-size typed array |
| `{x = 10, y = 20}` | `GenericRecord` | compile-time; converts to matching record type |
| `nil` | `*Unit` | null pointer |

## Definitions

> **Access modifiers:** `public` and `private` can be applied to any definition.
> If omitted, the **default** access is used: at module level, default = `private`.
> For named record fields, the default can be changed with the `@public { ... }` attribute on the record — fields listed inside the block become public.
> Anonymous record fields are `public` by default.

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
var x: Int32                       // zero-initialized: scalar → 0, record/array → all fields/elements zero
var x: Int32 = 10                  // with initial value
var x = 10                         // type inferred from value
var x, y, z: Int32                 // multiple vars of same type

const max = 100                    // module-level constant (type inferred)
const pi: Float64 = 3.14159        // with explicit type

let local = 42                     // immutable binding — only inside functions
```

> `let` is only allowed inside function bodies. For module-level values use `var` or `const`.

> `var` requires a concrete (non-generic) type — either declared explicitly or inferred from a non-generic initializer. `const` and `let` retain the compile-time generic type of their initializer.

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

Explicit type construction — not a cast. Takes a value of type A and produces a new value of type B.
Syntax: `TargetType sourceValue`

```modest
Int32 10                           // integer literal → Int32
Float64 3.14                       // rational literal → Float64
Nat8 0xFF                          // integer literal → Nat8
*Int32 ptr                         // pointer reinterpretation (unsafe)
Point {x = 1, y = 2}               // record construction
[4]Int32 [1, 2, 3]                 // explicit array (fills remaining with 0)
Unit value                         // discard a value (suppress warnings)
```

### Construction rules

> **Safe** — no special flag required.
> **Unsafe** — requires `-funsafe` compiler flag and `unsafe { }` block at the call site.
> Width notation: `Y≤X` means source width is narrower or equal; `Y>X` means wider.

| Target | Safe sources | Unsafe sources | Comment |
|---|---|---|---|
| `IntX` | `Integer`, `IntY`(Y≤X), `NatY`(Y≤X), `WordY`(Y≤X), `FloatY`, `Rational` | `IntY`(Y>X), `NatY`(Y>X), `WordY`(Y>X), `*T` | `FloatY→IntX` truncates fraction; compile-time overflow = error; `*T` only if pointer width ≤ X |
| `NatX` | `Integer`, `NatY`(Y≤X), `WordY`(Y≤X), `IntY`(Y≤X), `FloatY`, `Rational` | `NatY`(Y>X), `WordY`(Y>X), `IntY`(Y>X), `*T` | `IntY→NatX` applies `abs()`; `FloatY→NatX` truncates fraction |
| `WordX` | `Integer`, `WordY`(Y≤X), `IntY`(Y≤X), `NatY`(Y≤X), `CharY`(Y≤X), `Bool` | `WordY`(Y>X), `IntY`(Y>X), `NatY`(Y>X), `FloatY`, `*T` | signed→Word zero-extends (not sign-extends); `FloatY→WordX` reinterprets bits |
| `FloatX` | `Integer`, `Rational`, `IntY`, `NatY`, `FloatY`, `Fixed` | `WordY` | `WordY→FloatX` reinterprets bits |
| `*T` | `nil`, `*[N]T→*[]T`, `*Unit`, `String→*[]CharX`, `*[]T→*[N]T` | `*U`, `WordY`, `IntY` | `*[]T→*[N]T` safe only if element types match; otherwise full reinterpret = unsafe |
| `CharX` | `Integer`(≤X), `WordY`(Y≤X), `String`(len=1) | any numeric | `String→CharX` compile-time only; string must be exactly 1 character |
| `Bool` | `Bool` | — | no construction from other types; use `==` / `!=` to produce Bool |
| `[N]T` | `GenericArray` (len≤N) | — | missing elements are zero-filled |
| `RecordT` | `GenericRecord` | — | field names and types must match |
| `Unit` | any | — | discards the value; suppresses unused-value warning |

> **Non-obvious behaviors to keep in mind:**
> - `IntY → NatX` applies `abs()` — this is a semantic conversion, not a bitwise reinterpretation.
> - `signed → WordX` zero-extends, **not** sign-extends. `Int32 -1` → `Word64` gives `0x00000000FFFFFFFF`, not `0xFFFFFFFFFFFFFFFF`.
> - `FloatY → WordX` and `WordY → FloatX` always **reinterpret bits** (like `memcpy`), never do numeric conversion.

## Annotations

### Inlining
```modest
@inline                            // suggest inlining to backend
@inlinehint                        // weak inline hint (weaker than @inline)
@noinline                          // forbid inlining
```

### Linkage & C interop
```modest
@extern                            // external symbol (C linkage)
@extern("C", "symbol_name")        // maps to a different C symbol name
@c_include("header.h")             // emit #include in C output
@cbyvalue                          // pass record by value in C ABI (not by pointer)
```

### Symbol lifetime & diagnostics
```modest
@used                              // keep symbol even if unreferenced (prevent dead-code elimination)
@unused                            // suppress unused-symbol warning
@deprecated                        // mark symbol as deprecated
```

### Type layout & memory
```modest
@branded                           // newtype wrapper (nominal typing)
@layout("packed")                  // packed struct (no padding)
@layout("union")                   // union-style record (all fields at offset 0)
@volatile                          // volatile memory
@alignment(N)                      // set alignment to N bytes (C: __attribute__((aligned(N))), LLVM: align N)
@section("segment, section")       // place symbol in a specific linker section
```

### Access control
```modest
@public { field1, field2 }         // make listed fields of a named record public by default
```

### Unstable / internal
> These annotations exist in the compiler but are not stable and may change or be removed.

```modest
@nonstatic                         // suppress static linkage on a definition (C backend internal)
@c_no_print                        // suppress C output for this module (pragma-level, internal)
@zarray                            // zero-terminated array marker (internal)
@fraction(N)                       // fixed-point fractional bits (experimental)
```

### Examples
```modest
@inline
func min (a: Int32, b: Int32) -> Int32 {
    if a < b { return a }
    return b
}

@noinline
func expensive (x: Int32) -> Int32 {
    // ...
    return x
}

@extern("C", "malloc")
func my_alloc (size: Nat64) -> *Unit

@c_include("sys/types.h")
type MyHandle = Int32

@used
var table: [256]Word8              // kept even if never referenced

@deprecated
func old_api () -> Unit

@alignment(8)
var aligned_buf: [64]Word8

@section("__DATA, .xdata")
var xdata: [16]Word8

type Vec2 = @public {
    x: Float32
    y: Float32
}

type Color = @layout("union") {
    rgba: Word32
    r: Word8
}
```


## Code Style

- Between semantically distinct top-level blocks (includes, type definitions, constants) — **one empty line**
- Between function definitions — **two empty lines**
- Inline comments (to the right of a line of code) are separated from the code by **two spaces**

```modest
include "libc/ctypes64"
include "libc/stdio"

type Point = {x: Float64, y: Float64}

const maxSize = 100


func init (p: *Point) -> Unit {
    p.x = 0.0  // set x to origin
    p.y = 0.0  // set y to origin
}


func distance (a: Point, b: Point) -> Float64 {
    let dx = a.x - b.x  // x delta
    let dy = a.y - b.y  // y delta
    return sqrt(dx*dx + dy*dy)
}
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

### Enum Idiom

Modest has no built-in enum type. The idiomatic pattern is a branded integer type plus module-level constants:

```modest
type Color = @brand Nat8
const colorRed   = Color 0
const colorGreen = Color 1
const colorBlue  = Color 2
```

The `@brand` annotation makes `Color` nominally distinct from `Nat8` — you cannot mix them accidentally.
Use `Nat8` for up to 256 variants, or `Nat16`/`Nat32` for larger enumerations.

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


## Name Mapping (Modest → C / LLVM IR)

By default, symbol names are emitted as-is. Module imports add a prefix for public symbols.

| Situation | Modest | C / LLVM IR |
|---|---|---|
| Private symbol | `myFunc` | `myFunc` |
| Public symbol in module `utils` | `pub myFunc` | `utils_myFunc` |
| `include`d symbol | used directly | original name, no prefix |
| `@extern` | `myFunc` | `myFunc` (no module prefix) |
| `@extern("C", "malloc")` | `myAlloc` | `malloc` |
| `@alias("myAlias")` | `myFunc` | `myAlias` (C and LLVM) |
| `@alias("c", "myAlias")` | `myFunc` | `myAlias` (C only) |
| `@alias("llvm", "myAlias")` | `myFunc` | `myAlias` (LLVM only) |

```modest
// module: utils

public func greet () -> Unit { ... }   // emitted as: utils_greet
private func helper () -> Unit { ... } // emitted as: helper  (private, no prefix)

@extern("C", "printf")
public func myPrint (s: Str8) -> Unit  // emitted as: printf
```

> `public` marks a symbol as public (visible to importers). The module name becomes a prefix in the output.
> `private` (default) keeps the symbol local — no module prefix is added.
> `@extern` suppresses the module prefix — the symbol links directly to an external name.


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
