# Unary Operations

## Form

```
<#operator#> <#value_expression#>
```

| Operator | Operand | Result | Meaning |
| :-- | :-- | :-- | :-- |
| `not` | Bool | Bool | logical negation |
| `~` | WordX | operand type | bitwise inversion |
| `-` | IntX, FloatX, FixedX, Integer, Rational | operand type | arithmetic negation |
| `+` | IntX, FloatX, FixedX, Integer, Rational | operand type | no-op |
| `&` | mutable value or function | pointer | address-of |
| `*` | pointer | pointee | dereference |

## Semantics

- Each operator takes one class of operand and no other. `not` is the
  Bool operator and `~` is the Word one — they are not two spellings of
  one thing, and neither crosses to the other's type. `-` and `+` take a
  number: `IntX`, `FloatX`, `FixedX`, or one of the compile-time literal
  types `Integer` and `Rational` — so `-5` and `-1.5` are negated before
  they ever reach a concrete type.
- So `-` requires a *signed* type: negating a `Nat` is an error
  (`expected value with signed type`). It is not defined on `WordX`
  either — a bit pattern is not a quantity, the same split
  [binary](./binary.md) draws for arithmetic and ordering.
- Most of this is not enforced yet: `not` on an `IntX`, `~` and `+` on a
  `Bool`, `-` on a `WordX` all compile today, and `~` on a `FloatX` is
  refused by the C compiler rather than by modest. See BUG#64 — the
  table above is the rule, not a description of the current compiler.
- `&` applies to mutable values (variables, fields, elements) and
  functions. Immutable values — `let` bindings, parameters,
  constants — have no address (`expected mutable value or function`).
- `*p` designates the pointed-to value (a place): readable, assignable
  (`*p = 10`). Records and arrays behind pointers are accessed without
  explicit `*` — see [pointer](../type/pointer.md).
- `new` is parsed as a unary operator but is experimental — do not use.

## Examples

```modest
var flag: Bool = false
flag = not flag

var mask: Word8 = 0x0F
mask = ~mask                  // 0xF0

var x: Int32 = 5
let neg = -x

var p: *Int32 = &x
*p = 10                       // x == 10
```

## See also

- [Pointer type](../type/pointer.md), [Binary operations](./binary.md)
