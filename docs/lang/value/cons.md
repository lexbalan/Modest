# Value Construction

Modest has no type casts. A value of one type is obtained from another by
*construction*: the target type applied to a source value produces a new
value. Construction is *implicit* (at assignment, initialization, call,
return), *explicit* (written in code) or *unsafe* (explicit, requires the
`unsafe` keyword at the use site and `pragma unsafe` in the module).

## Form

```
<#type#> <#value_expression#>            // explicit
unsafe <#type#> <#value_expression#>     // unsafe
```

```modest
Int32 x
Float64 (a + b)
*Point nil
unsafe Nat64 p           // pointer address as integer
```

## Semantics

Per-target rules (`X`, `Y` — widths; verified against the compiler):

| Target | Implicit | Explicit | Unsafe only |
| :-- | :-- | :-- | :-- |
| `IntX` | `Integer`, `IntY` Y≤X | + `NatY`, `WordY` Y≤X; `FloatY`; `Rational` | wider sources; `*T` |
| `NatX` | `Integer`, `NatY` Y≤X | + `IntY`, `WordY` Y≤X; `FloatY` (`IntY` applies `abs`) | wider sources; `*T` |
| `WordX` | `Integer`, `WordY` Y≤X | + `IntY`, `NatY`, `CharY`, `FloatY` Y≤X; `Bool` | wider sources; `*T` |
| `FloatX` | `Rational`, `Integer`, `FloatY` | + `IntY`, `NatY`, `Fixed` | `WordY` (bit reinterpret) |
| `CharX` | length-1 `String`; generic char | + `Integer`, `WordY` Y≤X | any numeric |
| `Bool` | `Bool` | — (use `x != 0`) | — |
| `*T` | `nil`; `*[N]T`→`*[]T`; `String`→`*[]CharX` | `*Unit`→`*T`, `*T`→`*Unit` | `*U` (other pointee); integer sources |
| `[N]T` | generic array, same length | generic array, shorter (zero-fills tail) | — |
| record | generic record, same fields | generic record, missing fields zero-fill | — |
| `Unit` | — | any (discards the value) | — |
| `@branded T` | nothing implicit | parent `T` and back | — |

Key behaviors:

- Compile-time overflow is an error: `Nat8 256` does not compile.
- `IntY → NatX` applies `abs()` — a numeric conversion, not bit
  reinterpretation.
- signed → `WordX` zero-extends, **not** sign-extends.
- `FloatY ↔ WordX` reinterprets bits (like `memcpy`), never converts
  numerically. **Not implemented**: both backends convert numerically
  instead, and the LLVM one emits IR that does not assemble
  (`docs/BUGS.md` #36).
- `FloatY → IntX/NatX` truncates the fraction. **Partly implemented**:
  a float wider than the integer is refused as `integer overflow`, so only
  `Int64 ← Float64` and `Int32 ← Float32` work (`docs/BUGS.md` #37).
- Operands of binary operations are **not** promoted implicitly —
  construct explicitly to a common type first
  (see [binary](./binary.md)).

## Examples

```modest
var i: Int32 = 5
var f: Float64 = Float64 i        // numeric conversion
var w: Word32 = Word32 i          // zero-extending reinterpret
var b: Bool = i != 0              // no Bool construction

var a: [10]Int32 = [10]Int32 [1, 2, 3]   // tail zero-filled
var p: Point3D = Point3D {x = 1}         // y, z zero-filled

pragma unsafe                      // module opts into unsafe
let addr = unsafe Nat64 &i         // pointer -> address
let q = unsafe *Float32 &i         // reinterpret pointee
```

## See also

- [Generic types](../type/generic.md) — what converts implicitly
- [Branded types](../type/branded.md)
