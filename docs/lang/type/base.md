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
| `Float16/32/64` | 2–8 | equ, ord, math | IEEE 754 |
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

> `FixedX` is experimental. Literals, constants, arithmetic between them,
> and construction to and from other types — at compile time and at run time
> alike — all apply the scale, and both backends agree. What is left sits
> around the type rather than in it: `Fixed64` `*` and `/` need a 128-bit
> intermediate and so do not compile for a 32-bit target in C, `NatX` does
> not accept a `FixedX` source, and the `modest` backend drops
> `@fraction`'s argument. See `docs/BUGS.md` (#25),
> `tests/lang/type/fixed/runtime.modest` (the type at run time) and
> `tests/lang/type/fixed/comptime.modest` (the compile-time fold).

> `FloatX` is IEEE 754 and complete for arithmetic, ordering and the
> conversions to and from the other numeric types. `Float16` is binary16 in
> both backends — `_Float16` in C11, `half` in LLVM — and reaches only the
> targets that have it: it is absent on ppc64le, wasm and msp430, the same
> way `__int128` behind `Word128` is. Several things around `FloatX` do not
> hold: `FloatX` ↔ `WordX` converts numerically instead of
> reinterpreting bits, an `IntX`/`NatX` narrower than the float is refused,
> and the LLVM backend gets unary `-` and `!=` on a NaN wrong and builds the
> `FixedX` scale at the source float's width — which only a `Float16` source
> is narrow enough to expose. A literal outside the type's range is a
> compile-time error in both backends, the way an integer one is
> ([cons](../value/cons.md)). See `docs/BUGS.md` (#34–#37, #40) and
> `tests/lang/type/float/`, where each has a marked reproducer next to the
> files that pass.

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
