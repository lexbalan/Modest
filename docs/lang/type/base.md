# Base Types

Primitive built-in types.

## Form

| Type | Size (bytes) | Operations | Description |
| :--- | :-: | :--- | :--- |
| `Unit` | 0 | — | empty type (`void` in C) |
| `Bool` | 1 | equ, logic | `true` / `false` |
| `Word8/16/32/64/128` | 1–16 | equ, bitwise | bit words |
| `Int8/16/32/64/128` | 1–16 | equ, ord, math, rem | signed integers |
| `Nat8/16/32/64/128` | 1–16 | equ, ord, math, rem | unsigned integers |
| `Char8/16/32` | 1–4 | equ | characters (UTF-8/16/32 code units) |
| `Float32/64` | 4–8 | equ, ord, math | IEEE 754 |
| `Fixed32/64` | 4–8 | equ, ord, math | fixed-point (experimental) |

Operation classes:

| Class | Operations |
| :--- | :--- |
| equ | `==` `!=` |
| ord | `<` `>` `<=` `>=` |
| logic | `and` `or` `not` (Bool only) |
| bitwise | `&` `\|` `^` `~` `<<` `>>` (Word only) |
| math | `+` `-` `*` `/`, unary `-` |
| rem | `%` |

Target-width aliases (resolved from target config): `Int`, `Nat`, `Word`,
`Size`; `Byte` is an alias for `Word8`.

## Semantics

- Alignment of every base type equals its size, except `alignof(Unit) = 1`.
- The classes are strict: there is no arithmetic on `Word` (bit
  manipulation only), no bitwise operations on `Int`/`Nat`, no ordering
  on `Char`. Convert explicitly via [construction](../value/cons.md)
  when an operation is needed.
- There is no `xor` keyword; `^` is the (Word-only) exclusive-or.
- `Unit` marks the absence of a value: function with no return value,
  explicit discard (`Unit x`), and the free pointer `*Unit`
  (see [pointer](./pointer.md)).
- `Fixed32`/`Fixed64` carry a binary point set by `@fraction(N)`
  (default 16 for `Fixed32`, 32 for `Fixed64`). A value is stored as the
  number multiplied by `2^fraction`.

> `FixedX` is only half built. Everything the compiler can work out at
> compile time is correct — literals, constants, arithmetic between them,
> and construction to and from other types all apply the scale, and both
> backends agree. Arithmetic on `FixedX` **variables** is still emitted as
> plain integer arithmetic, so a product comes out `2^fraction` too large
> and a quotient that much too small. See `docs/BUGS.md` (#25),
> `tests/lang/type/fixed.modest` (what is still broken) and
> `tests/lang/type/fixed_const.modest` (what works).

## Examples

```modest
var flag: Bool = true
var mask: Word8 = 0x0F | 0x40      // bitwise on Word
var count: Nat32 = 0               // arithmetic on Nat
var ratio: Float64 = 1.5

count = count + 1
mask = mask << 2

var fx: Fixed32 = 3.14             // 16.16 fixed-point
var fx12: @fraction(12) Fixed32    // 20.12 fixed-point
```

## See also

- [Generic types](./generic.md) — the compile-time types of literals
- [Value construction](../value/cons.md) — converting between base types
