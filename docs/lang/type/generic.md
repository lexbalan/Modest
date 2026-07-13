# Generic Types

A *generic type* is the compile-time type of a literal or constant
expression. Generic values exist only at compile time; at a use site they
implicitly construct a value of the required concrete type.

## Form

| Generic type | Produced by | Implicitly converts to |
| :--- | :--- | :--- |
| `Integer` | `0`, `42`, `0xFF` | IntX, NatX, WordX, FloatX (width permitting) |
| `Rational` | `3.14`, `0.5` | FloatX |
| `String` | `"abc"`, `'abc'` | `[N]CharX` arrays (see [array](./array.md)) |
| generic char | `"A"[0]` | CharX |
| generic array | `[1, 2, 3]` | same-size array of compatible element type |
| generic record | `{x=1, y=2}` | record with the same fields |

## Semantics

- A generic value tracks its minimal width: `Integer(8)` for `42`. The
  implicit conversion succeeds if the target is wide enough; overflow is
  a compile-time error.
- Expressions over generic values are evaluated at compile time and stay
  generic: `const two = 1 + 1` is still `Integer`.
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

## See also

- [Value construction](../value/cons.md) — explicit conversions
- [Literals](../value/literal.md)
