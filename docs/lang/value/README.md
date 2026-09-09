# Values

A *value expression* computes a value. Expressions are built from
literals, names and the operations below.

| Expression | Form | Page |
| :-- | :-- | :-- |
| Literal | `42`, `3.14`, `"abc"`, `[1, 2]`, `{x = 1}`, `true`, `nil` | [literal](./literal.md) |
| Construction | `TargetType value` | [cons](./cons.md) |
| Binary | `+ - * / %`, `== != < <= > >=`, `and or`, `& \| ^ << >>` | [binary](./binary.md) |
| Unary | `not ~ - + & *`; `new` *(experimental)* | [unary](./unary.md) |
| Access | `record.field` | [access](./access.md) |
| Index | `arr[i]` | [index](./_index.md) |
| Slice | `arr[i:j]` | [slice](./slice.md) |
| Call | `f(args)` | [call](./call.md) |
| Size queries | `sizeof` / `alignof` / `lengthof` / `offsetof` | [sizeof](./sizeof.md) |

## Operator precedence

From loosest to tightest binding:

| Level | Operators |
| :-: | :--- |
| 1 | `or` |
| 2 | `and` |
| 3 | `==` `!=` `<` `>` `<=` `>=` |
| 4 | `+` `-` `&` `\|` `^` `<<` `>>` |
| 5 | `*` `/` `%` |
| 6 | construction (`Type value`) |
| 7 | unary: `*` `&` `not` `~` `+` `-` |
| 8 | postfix: call `()`, index `[]`, slice `[:]`, access `.` |
| 9 | literals, names, `(...)` |

Every binary level is left-associative — a chain groups from the left, and
that holds for `or`, `and` and the bitwise operators as well as for
arithmetic.

Level 4 holds the arithmetic and the bitwise operators together, but the
two never meet in one expression: `+` `-` want `IntX` / `NatX` / `FloatX`
and `&` `|` `^` `<<` want `WordX`, so a mixed chain is a type error, not a
grouping question. Within the bitwise half the level is flat: `&` does not
bind tighter than `|`, and a shift does not bind tighter than either.

On level 3 an equality and an ordering may not be chained without
parentheses — `a == b < c` is rejected with `required parentheses`, since
the left-associative reading `(a == b) < c` compares two `Bool`s and is
never what was meant. A chain of `==` / `!=` alone is allowed.

Binding examples (lower level = binds tighter):

```modest
w & mask == 0            // (w & mask) == 0   — bitwise tighter than ==
a == 1 and b == 2        // (a == 1) and (b == 2)
hi << 8 | lo             // (hi << 8) | lo    — left to right, as in C
lo | hi << 8             // (lo | hi) << 8    — left to right, NOT as in C
10 - 3 - 2               // (10 - 3) - 2 = 5  — left-associative
s ^ 0x0F ^ 0x30          // (s ^ 0x0F) ^ 0x30
```

A shift written to the right of `&` `|` `^` is the one place where the
grouping differs from C and the types stay happy, so nothing is reported:
write the parentheses there.

```modest
let both = (big >> 32) << 32 | (big << 32) >> 32   // groups as (... | ...) >> 32
let both = ((big >> 32) << 32) | ((big << 32) >> 32)
```

## Value categories

- **Immediate** — known at compile time: literals, `const`, and any
  expression over immediate operands (folded by the compiler).
- **Immutable** — not assignable: immediates, `let` bindings, function
  parameters. Taking the address of an immutable value is an error
  (`expected mutable value or function`).
- **Default value** — every type has one: `false` / `0` / `nil` /
  `{}` / `[]`. Globals without an initializer hold the default value of
  their type; record fields may override theirs
  (see [fields](../fields.md)).
