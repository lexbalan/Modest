# Binary Operations

## Form

```
<#left#> <#operator#> <#right#>
```

| Group | Operators | Operand types | Result |
| :-- | :-- | :-- | :-- |
| Equality | `==` `!=` | Bool, IntX, NatX, WordX, CharX, FloatX, arrays, records, pointers | `Bool` |
| Ordering | `<` `>` `<=` `>=` | IntX, NatX, FloatX | `Bool` |
| Arithmetic | `+` `-` `*` `/` `%` | IntX, NatX, FloatX (`%`: integers only) | operand type |
| Logical | `and` `or` | Bool | `Bool` |
| Bitwise | `&` `\|` `^` | WordX | operand type |
| Shift | `<<` `>>` | left: WordX; right: unsigned integer (NatX, WordX, literal) | left type |

## Semantics

- **Operand types must match exactly** — there are no implicit numeric
  promotions: `Int32 + Int64` is an error (`different types ... in
  operation`). Construct to a common type explicitly. Generic literals
  adapt to the other operand: `i + 1` works for any integer `i`.
- The only exception is shift: the right operand's type may differ from
  the left's.
- Equality extends to composites: arrays and records compare element- /
  field-wise, pointers compare addresses (`p == nil`).
- No ordering on `Char`, `Word`, `Bool`, pointers.
- There is no `xor` keyword: exclusive-or is `^` (Word). `and` / `or`
  are Bool-only.
- Division of integers truncates; `%` is the remainder.

## Examples

```modest
var a: Int32 = 10
var b: Int32 = 3
let q = a / b                  // 3
let r = a % b                  // 1

var w: Word8 = 0x0F
let m = (w << 4) | (w & 0x3)   // bit manipulation

let inRange = x >= lo and x <= hi

var h1, h2: [32]Word8
// ...
if h1 == h2 { printf("hashes match\n") }
```

## See also

- [Unary operations](./unary.md), [Construction](./cons.md)
- [Operator precedence](./README.md#operator-precedence)
