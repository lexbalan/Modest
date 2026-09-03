# Modest Language Cheat Sheet

Quick reference for writing Modest code.

## Types

> Type identifiers always start with a capital letter.
> Variables, constants and function identifiers use camelCase.
> Language style: PascalCase for types, camelCase for everything else.
> Identifiers are ASCII only; Unicode is allowed in comments and string literals.

> Instead of type cast there is a value construction operation: `Int32 5`, `[4]Int32 [1, 2, 3, 4]`, etc.

> Pointers do not work like arrays in C — to index through a pointer you need a pointer to array `*[]Type`.


### Base Types
```modest
Integer                            // compile-time type for integer literals — implicitly cast to IntX, NatX, WordX, FloatX, FixedX
Rational                           // compile-time type for rational literals — implicitly cast to FloatX, FixedX
Unit                               // void (empty type)
Bool                               // true, false
Int8, Int16, Int32, Int64, Int128  // signed integers
Nat8, Nat16, Nat32, Nat64, Nat128  // unsigned integers
Word8, Word16, Word32, Word64, Word128  // bitwise integers
Char8, Char16, Char32              // characters
Float16, Float32, Float64          // floating point (Float16 needs a target that has it)
Fixed32, Fixed64                   // fixed-point — run-time * and / not rescaled by the LLVM backend (BUGS.md #25)
Str8, Str16, Str32                 // aliases for: []Char8, []Char16, []Char32 (string values are passed as *Str8)
Int, Nat, Word                     // target-width integer aliases (builtin)
Byte                               // builtin byte type
Size                               // target size type (like size_t)
Ptr                                // alias for *Unit (untyped pointer)
```

### Compile-time (Generic) Types

Literals have a *compile-time type* that is resolved to a concrete type at use site.
These are sometimes called **generic** types internally.

| Compile-time type  | Literal form              | Implicitly converts to          |
|--------------------|---------------------------|---------------------------------|
| `Integer`          | `0`, `42`, `0xFF`         | IntX, NatX, WordX, FloatX, FixedX |
| `Rational`         | `3.14`, `0.5`             | FloatX, FixedX                  |
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

> `Rational` is backed by an exact arbitrary-precision fraction, not a
> float — a literal can carry more digits than any `FloatX` holds. The
> builtin constant `builtin.target.rationalPrecision` (Integer, 256 by
> default, mirrors `precision` in `cfg/*.toml`) is how many significant
> decimal digits the C backend keeps when it writes such a literal out
> as text (currently unreachable, like the rest of `builtin.*` — see
> `docs/BUGS.md` #5) — see
> [docs/lang/type/generic.md#rational-precision](lang/type/generic.md#rational-precision).

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
| `42`, `0xFF` | `Integer` | compile-time; converts to IntX, NatX, WordX, FloatX, FixedX. *Not* to `CharX` — that needs value construction: `Char8 65` |
| `3.14`, `0.5` | `Rational` | compile-time; converts to FloatX, FixedX |
| `true`, `false` | `Bool` | | non-generic; just Bool
| `"Hello World"` | `String` | compile-time; converts to CharX or StrX (`*[]CharX`) |
| `'Hello World'` | `String` | same; no char literal — use value construction: `Char8 'A'` |
| `[1, 2, 3]` | `GenericArray` | compile-time; converts to same-size typed array |
| `{x = 10, y = 20}` | `GenericRecord` | compile-time; converts to matching record type |
| `nil` | `*Unit` | null pointer |

## Definitions

> **Access modifiers:** `public` and `private` can be applied to any definition.
> If omitted, the entity gets the internal **default** access, which resolves by context:
> - module-level definitions: default → `private` (or `public` if the module has `pragma public_module`)
> - named record fields: default → `private`; with the `@public` attribute on the record, default → `public`
> - anonymous record fields: default → `public`
>
> Privacy is enforced only across modules — inside the defining module, `private` fields are freely accessible.

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

// EXPERIMENTAL: signature borrowed from a named function type, params come
// from the type; can't mix with inline (params) -> Return on the same def
type FailHandler = (code: Int32) -> Unit
func onDiskFail: FailHandler {
    printf("disk failed with code %d\n", code)
}
```

> **Parameters are immutable.** A parameter cannot be assigned to, and
> neither can anything inside it — the argument arrives as a value the
> callee may read but not edit. Copy it into a local `var` to modify.
>
> ```modest
> func f (n: Int32, p: Point, a: [2]Int32) -> Int32 {
>     n = 1        // error: expected lvalue
>     p.x = 1      // error: expected mutable value
>     a[0] = 1     // error: expected mutable value
>     var m = n    // this is how you get something writable
>     m = 1
>     return m
> }
> ```

### Variables & Constants
```modest
var x: Int32                       // global: zero-init; local: must assign before use (compile error otherwise)
var x: Int32 = 10                  // with initial value
var x = 10                         // type inferred from value
var x, y, z: Int32                 // multiple vars of same type
@immutable var x: Int32 = 10      // immutable var — cannot be reassigned after initialization

const max = 100                    // module-level constant (type inferred)
const pi: Float64 = 3.14159        // with explicit type

let local = 42                     // immutable binding — only inside functions
```

> `let` is only allowed inside function bodies. For module-level values use `var` or `const`.

> `var` always gets a concrete type: declared explicitly, inferred from the initializer, or — for generic literals (`var i = 0`) — the target default type (Integer → Int, Rational → Float). `const` and `let` retain the compile-time generic type of their initializer.

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

### Line breaks

A statement ends at the end of the line — there are no semicolons. An expression
continues on the next line when the line ends with a token that cannot finish it:
a binary operator (`+`, `|`, `and`, `==`, ...), `=`, `,`, `(` or `[`.

```modest
let v = a |
	(a << 8) |
	(a << 16)

printf("%d %d\n",
	first,
	second)
```

> **The operator goes at the end of the line, not at the start of the next one.**
> It is the mark that the expression continues — the parser decides at the line
> break, using what it has already read. Starting a line with `|` gives
> `unexpected token1 '|'`.
>
> A blank line after the trailing operator is fine; an inline comment after it is
> not — that is a known bug, see [BUGS.md](BUGS.md) #22.

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

> Not assignable: `let` bindings, `const`, and function parameters
> (see [Functions](#functions)). There are no compound assignments
> (`+=`, `-=`, ...) — write `x = x + 1`, or `++x` / `--x`.

### Return
```modest
return value
return                             // for Unit functions
```

### Increment/Decrement
```modest
++i   // prefix only — it is a statement, not an expression
--j
```


## Operators

> **Both sides of a binary operation must be the same type.** There is no
> implicit widening — even a narrower operand is rejected:
>
> ```modest
> let a = Int32 1
> let b = Int64 2
> let c = a + b        // error: different types 'Int32' & 'Int64' in operation
> let d = Int64 a + b  // this is how you mix widths
> ```
>
> Holds for arithmetic, comparison (`==`, `<`, ...) and bitwise operators alike.
> A literal is not affected — it has a compile-time type and adopts the type of
> the other operand (`a + 5`, `w | 0xFF`).
>
> **Shifts are the exception**: `w << n` pairs a `WordX` left operand with a
> `NatX` count of any width, or a non-negative integer literal.

### Arithmetic
```modest
a + b, a - b, a * b, a / b, a % b
-a                                 // negation
```

### Comparison
```modest
a == b, a != b                     // any two values of the same type
a < b, a > b, a <= b, a >= b       // ordering: IntX, NatX, FloatX only
```

> `==` and `!=` are defined for **every** type, as long as both sides have the
> same type — records, arrays, pointers, `Bool` and `Word*` included:
>
> ```modest
> if a == b { ... }              // Point == Point — field by field
> if hash == expected { ... }    // [32]Word8 == [32]Word8 — element by element
> if p == nil { ... }            // pointer against nil
> ```
>
> Ordering is the narrow one: `<` `>` `<=` `>=` need a type that carries a
> number. A record, array or pointer operand is rejected with
> `unsuitable value type '...' for 'lt' operation`, and so are `Word*` and
> `Char*` — a bit pattern and a code unit are not quantities. Order them
> through an explicit `NatX`: `Nat32 w < Nat32 m`.

### Logical
```modest
a and b
a or b
not a
```

### Bitwise — Word* types only
```modest
w & m, w | m, w ^ m                // and, or, xor — both operands WordX
~w                                 // bitwise not
w << n, w >> n                     // shifts: left WordX; right NatX or a non-negative literal
```

> Bit manipulation is only defined for `Word*` types — this is a deliberate split:
> - `Int*` / `Nat*` support arithmetic and ordering, but **no bitwise ops**
> - `Word*` support bitwise ops and `==`/`!=`, but **no arithmetic and no ordering** (`<`, `>`, ...)
>
> To mix, convert explicitly via value construction: `Word32 i`, `Int32 w`.
> There is no `xor` keyword — exclusive-or is `^` (`and`/`or` are Bool-only).
> The shift count must be `NatX` or a non-negative integer literal — `WordX`,
> `IntX` and negative literals are all rejected with
> `expected natural or non-negative integer value`.

### Unary / Special
```modest
&x                                 // address of
*ptr                               // dereference
sizeof(Type)  sizeof(value)        // size in bytes
alignof(Type) alignof(value)       // alignment in bytes
lengthof(ArrayType)                // number of elements in array type
offsetof(RecordType.field)         // byte offset of field
```
> These fold at compile time into a value that carries the width it needs,
> so it goes into any `NatX` that fits — `var x: Nat16 = sizeof(T)` — and
> mixes with any numeric variable. With no type to take, it becomes `Size`
> (`var x = sizeof(T)`). Of a VLA, the size is a run-time `Size`.

### Access
```modest
arr[i]                             // index (element)
arr[i:j]                           // slice (sub-array)
record.field                       // field access
ptr.field                          // auto-deref field access (no -> needed)
func(args)                         // call
```

### Precedence

Loosest to tightest — each level binds tighter than the one above it.
Every binary level is left-associative: `10 - 3 - 2` is `5`, and a chain of
`or`, `and`, <code>&#124;</code>, `^` or `&` groups the same way.

| # | Operators | |
|---|---|---|
| 1 | `or` | loosest |
| 2 | `and` | |
| 3 | `==` `!=` | |
| 4 | <code>&#124;</code> | |
| 5 | `^` | |
| 6 | `&` | |
| 7 | `<` `>` `<=` `>=` | |
| 8 | `<<` `>>` | |
| 9 | `+` `-` | |
| 10 | `*` `/` `%` | |
| 11 | `Type value` (construction), `unsafe Type value` | |
| 12 | unary `-` `+` `not` `~` `&x` `*p`, `sizeof` `alignof` `lengthof` `offsetof` | |
| 13 | `f(args)` `x.field` `a[i]` `a[i:j]` | tightest |

> **Equality is looser than the bitwise operators, ordering is tighter.**
> `==`/`!=` sit above <code>&#124;</code> `^` `&` (level 3), so the classic C
> parenthesis trap is gone — `crc & 1 != 0` means `(crc & 1) != 0`, as it reads.
> But `<` `>` `<=` `>=` sit *below* them (level 7), so `w & x < y` parses as
> `w & (x < y)` and fails with `different types 'Word32' & 'Bool'`. Parenthesize
> ordering comparisons when mixing them with bitwise operators.

> **Construction binds tighter than every binary operator** (level 11):
> `Word64 b << 8` is `(Word64 b) << 8`, not `Word64 (b << 8)`.

> **A unary operator takes only a level-13 operand** — a name, literal, call,
> field, index or a parenthesized expression. `-x`, `~w`, `&arr[0]`, `not f()`
> are fine; `- -x`, `~ ~w` and `~ Word64 w` are syntax errors — parenthesize:
> `~ (Word64 w)`. Two exceptions: `*` (dereference) chains freely (`**pp`), and
> `unsafe` takes a whole expression (`unsafe Nat64 &x`).

## Value Construction

Explicit type construction — not a cast. Takes a value of type A and produces a new value of type B.
Syntax: `TargetType sourceValue`

```modest
Int32 10                           // integer literal → Int32
Float64 3.14                       // rational literal → Float64
Nat8 0xFF                          // integer literal → Nat8
unsafe *Int32 ptr                  // pointer reinterpretation (needs pragma unsafe)
Point {x = 1, y = 2}               // record construction
[4]Int32 [1, 2, 3]                 // explicit array (fills remaining with 0)
Unit value                         // discard a value (suppress warnings)
```

### Construction rules

> **Safe** — written as plain construction: `Nat8 x`.
> **Unsafe** — needs `pragma unsafe` in the module *and* the `unsafe` operator
> at the use site: `unsafe Nat8 x`. Permission lives in the source, not on the
> command line — the `-funsafe` flag is currently ignored (see
> [BUGS.md](BUGS.md) #19).
> Width notation: `Y≤X` means source width is narrower or equal; `Y>X` means wider.

| Target | Safe sources | Unsafe sources | Comment |
|---|---|---|---|
| `IntX` | `Integer`, `IntY`(Y≤X), `NatY`(Y≤X), `WordY`(Y≤X), `FloatY`, `FixedY`(Y≤X), `Rational` | `IntY`(Y>X), `NatY`(Y>X), `WordY`(Y>X), `FixedY`(Y>X), `*T` | `FloatY→IntX` and `FixedY→IntX` truncate the fraction toward zero; compile-time overflow = error; `*T` only if pointer width ≤ X |
| `NatX` | `Integer`, `NatY`(Y≤X), `WordY`(Y≤X), `IntY`(Y≤X), `FloatY`, `Rational` | `NatY`(Y>X), `WordY`(Y>X), `IntY`(Y>X), `*T` | `IntY→NatX` applies `abs()`; `FloatY→NatX` truncates fraction |
| `WordX` | `Integer`, `WordY`(Y≤X), `IntY`(Y≤X), `NatY`(Y≤X), `CharY`(Y≤X), `FloatY`(Y≤X), `FixedY`(Y≤X), `Bool` | `WordY`(Y>X), `IntY`(Y>X), `NatY`(Y>X), `FloatY`(Y>X), `FixedY`(Y>X), `*T` | signed→Word zero-extends (not sign-extends); `FloatY→WordX` reinterprets bits; `FixedY→WordX` gives the raw scaled storage |
| `FloatX` | `Integer`, `Rational`, `IntY`, `NatY`, `FloatY`, `FixedY` | `WordY` | `WordY→FloatX` reinterprets bits; `FixedY→FloatX` removes the scale; compile-time overflow = error (`Float16 70000.0`), at run time IEEE infinity |
| `FixedX` | `Integer`, `Rational`, `IntY`, `NatY`, `FloatY`, `FixedY` | `WordY` | applies the scale of the target's own `@fraction`; `WordY→FixedX` takes the raw storage as is |
| `*T` | `nil`, `*[N]T→*[]T`, `*Unit`, `String→*[]CharX`, `*[]T→*[N]T` | `*U`, `WordY`, `IntY` | `*[]T→*[N]T` safe only if element types match; otherwise full reinterpret = unsafe |
| `CharX` | `Integer`(≤X), `WordY`(Y≤X), `String`(len=1) | any numeric | `String→CharX` compile-time only; string must be exactly 1 character |
| `Bool` | `Bool` | — | no construction from other types; use `==` / `!=` to produce Bool |
| `[N]T` | `GenericArray` (len≤N) | — | missing elements are zero-filled |
| `RecordT` | `GenericRecord` | — | omitted fields take their default: the type's default value (`0`/`false`/`nil`/...) or the field's explicit `= value` |
| `Unit` | any | — | discards the value; suppresses unused-value warning |

> **Non-obvious behaviors to keep in mind:**
> - `IntY → NatX` applies `abs()` — this is a semantic conversion, not a bitwise reinterpretation.
> - `signed → WordX` zero-extends, **not** sign-extends. `Int32 -1` → `Word64` gives `0x00000000FFFFFFFF`, not `0xFFFFFFFFFFFFFFFF`.
> - `FloatY → WordX` and `WordY → FloatX` always **reinterpret bits** (like `memcpy`), never do numeric conversion.
> - `FixedX` values are stored scaled by `2^fraction`. Every construction into or out of `FixedX`
>   applies or removes that scale — except `WordX`, which is the raw storage in both directions.
>   Anything that does not land on a representable step is rounded to the nearest one,
>   with a half step going away from zero.
> - `NatX` is the one numeric target that does **not** accept a `FixedX` source, even though
>   `IntX` and `FloatY` both do — an asymmetry in `value_nat_can`, not a stated rule.

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
@cbyvalue                          // pass record by value in C ABI (not by pointer)
```

> To emit `#include` in C output use the **pragma** (module-level), not an annotation:
> `pragma c_include "header.h"`

### Symbol lifetime & diagnostics
```modest
@used                              // keep symbol even if unreferenced (prevent dead-code elimination)
@unused                            // suppress unused-symbol warning
@deprecated                        // mark symbol as deprecated
```

### Mutability
```modest
@immutable                         // var cannot be reassigned after initialization
```

### Type layout & memory
```modest
@branded                           // newtype wrapper (nominal typing)
@layout("packed")                  // packed struct (no padding)
@layout("union")                   // union-style record (all fields at offset 0)
@layout("exact")                   // exact layout (no reordering/padding changes)
@volatile                          // volatile memory
@const                             // const qualifier
@restrict                          // restrict qualifier (pointers/arrays)
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
@fraction(N)                       // fixed-point fractional bits — moves the binary point of a FixedX
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

@used
var table: [256]Word8              // kept even if never referenced

@deprecated
func old_api () -> Unit

@immutable
var maxItems: Int32 = 100

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
- At the end of a file — **two empty lines** as well (the file ends with `}\n\n\n`)
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
type Color = @branded Nat8
const colorRed   = Color 0
const colorGreen = Color 1
const colorBlue  = Color 2
```

The `@branded` annotation makes `Color` nominally distinct from `Nat8` — you cannot mix them accidentally.
Use `Nat8` for up to 256 variants, or `Nat16`/`Nat32` for larger enumerations.

### Multi-source Module
```modest
// main.modest
include "libc/ctypes64"
include "libc/stdio"
import "utils"

func main () -> Int {
    utils.greet()
    return 0
}

// utils.modest
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
| Public symbol in module `utils` | `public myFunc` | `utils_myFunc` |
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

> Because names are emitted as-is, a value identifier that is a **C keyword**
> (`double`, `switch`, `union`, `register`, ...) produces C that does not
> compile — the C backend does no mangling. Type identifiers are safe (C
> keywords are all lowercase); the LLVM backend is unaffected. See
> [identifiers](lang/identifier.md#names-reserved-by-the-c-backend).


## Key Differences from C

| Feature          | C                              | Modest                                    |
|------------------|--------------------------------|-------------------------------------------|
| Function sig     | `int add(int a, int b)`        | `func add (a: Int32, b: Int32) -> Int32`  |
| Variable decl    | `int x = 10;`                  | `var x: Int32 = 10`                       |
| Struct           | `struct Point { int x; int y; }` | `type Point = {x: Int32, y: Int32}`     |
| Field via ptr    | `ptr->field`                   | `ptr.field` (auto-deref)                  |
| Arrays           | `int arr[10]`                  | `var arr: [10]Int32`                      |
| Array semantics  | decays to pointer              | ordinary value type: passed, returned, assigned **by value** (no decay) |
| Return type      | `int func()`                   | `func name () -> Int32`                   |
| Void             | `void func()`                  | `func name () -> Unit`                    |
| Logical ops      | `&&`, `\|\|`, `!`              | `and`, `or`, `not`                        |
| Bitwise ops      | any integer type               | only `Word*` types (`&` `\|` `^` `~` `<<` `>>`) |
| Continue         | `continue`                     | `again`                                   |
| Type system      | implicit/weak                  | strict, explicit                          |
| Namespaces       | none                           | `import "mod"` → `mod.name`               |


## Compilation

```bash
mcc -o main -mbackend=c11 main.modest       # translate to C (main.c)
mcc -o main -mbackend=llvm main.modest      # translate to LLVM IR (main.ll)
mcc -o main -mbackend=modest main.modest    # re-emit Modest source (main.modest, pretty-printed)

mcc -o main -mbackend=c11 -fparanoid main.modest   # warnings as errors
```
