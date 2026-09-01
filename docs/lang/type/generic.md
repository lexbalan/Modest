# Generic Types

A *generic type* is the compile-time type of a literal or constant
expression. Generic values exist only at compile time; at a use site they
implicitly construct a value of the required concrete type.

## Form

| Generic type | Produced by | Implicitly converts to |
| :--- | :--- | :--- |
| `Integer` | `0`, `42`, `0xFF` | IntX, NatX, WordX, FloatX, FixedX (width permitting) |
| `Rational` | `3.14`, `0.5` | FloatX, FixedX |
| `String` | `"abc"`, `'abc'` | `[N]CharX` arrays (see [array](./array.md)), `StrX`, and `CharX` if the length is exactly 1 |
| generic char | `"A"[0]` | CharX |
| generic array | `[1, 2, 3]` | same-size array of compatible element type |
| generic record | `{x=1, y=2}` | record with the same fields |

## Semantics

- A generic value tracks its minimal width: `Integer(8)` for `42`. The
  implicit conversion succeeds if the target is wide enough; overflow is
  a compile-time error.
- Expressions over generic values are evaluated at compile time and stay
  generic: `const two = 1 + 1` is still `Integer`.
- `Rational` is backed by an exact arbitrary-precision fraction (unlike
  `FloatX`, which is a fixed-width IEEE754 value) — a literal can carry
  more significant digits than any `FloatX` can hold, and folding
  `+ - * /` between `Rational` values never rounds (division by a
  `Rational` zero is a compile-time error). See
  [Rational precision](#rational-precision) below for how much of that
  exactness survives into generated code.
- `const` and `let` preserve the generic type of their initializer; the
  value adapts independently at each use site. `var` forces a concrete
  type (the target default for a bare literal — see
  [var](../def/var.md)).
- The **empty literals** `[]` and `{}` implicitly convert to *any* array
  or record type and zero-fill it.
- A generic array converts implicitly to an array of the same length;
  construction to a longer array zero-fills the tail:
  `[10]Int32 [1, 2, 3]`.
- A generic record converts implicitly to a record with exactly the same
  field names; construction to a record with extra fields zero-fills
  them.
- Branded types are never an implicit target — see
  [branded](./branded.md).

## Examples

```modest
const n = 42                // Integer
var a: Int8 = n             // fits: ok
var b: Float64 = n          // Integer -> Float64
var w: Word16 = n           // Integer -> Word16

var buf: [256]Word8 = []    // zero-filled
var v: [4]Int32 = [1, 2, 3, 4]
var p: Point = {x = 1, y = 2}
```

## Rational precision

```modest
// more digits than a Float64 can represent — kept exactly at compile time
const pi = 3.14159265358979323846264338327950288419716939937510582097494459
```

- [`builtin.target.rationalPrecision`](../builtin_constants.md) (an
  `Integer` constant, 256 by default) is how many significant decimal
  digits the **C backend** writes out when it renders a
  `Rational`/`Float` constant literal as text. It mirrors `precision` in
  `cfg/*.toml` and is otherwise unused — `Rational` arithmetic itself is
  already exact regardless of this setting. It is currently unreachable
  like the rest of `builtin.*` — see `docs/BUGS.md` (#5).
- Raising `precision` only helps a *single literal* wider than the
  default 256 digits — a real but narrow case. It does not increase the
  precision of a `FloatX`-typed variable at runtime: once the C compiler
  parses the emitted text, the value still rounds to the target's actual
  width (`double`, etc.).
- The **LLVM backend** rounds every `Rational`/`Float` constant to
  `Float64` immediately during code generation, so `rationalPrecision`
  has no effect there.
- Compound expressions carry through: `3.14 + 0.5` is folded as an exact
  `Fraction` and written out at `precision` digits, the same as a bare
  literal. The arithmetic is never handed back to the C compiler to redo
  — that would round twice and land on a different number (`0.1 + 0.2`
  is `0.29999999999999998890` folded exactly, `0.30000000000000004441`
  added as two doubles).

## See also

- [Value construction](../value/cons.md) — explicit conversions
- [Literals](../value/literal.md)
- [Builtin constants](../builtin_constants.md) — `builtin.target.rationalPrecision`
