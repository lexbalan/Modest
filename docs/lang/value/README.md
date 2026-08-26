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
| 3 | `==` `!=` |
| 4 | `\|` |
| 5 | `^` |
| 6 | `&` |
| 7 | `<` `>` `<=` `>=` |
| 8 | `<<` `>>` |
| 9 | `+` `-` |
| 10 | `*` `/` `%` |
| 11 | construction (`Type value`) |
| 12 | unary: `*` `&` `not` `~` `+` `-` |
| 13 | postfix: call `()`, index `[]`, slice `[:]`, access `.` |
| 14 | literals, names, `(...)` |

Every binary level is left-associative — a chain groups from the left, and
that holds for `or`, `and`, `|`, `^` and `&` as well as for arithmetic.

Binding examples (lower level = binds tighter):

```modest
w & mask == 0            // (w & mask) == 0   — bitwise tighter than ==
a == 1 and b == 2        // (a == 1) and (b == 2)
w << n + 1               // w << (n + 1)     — arithmetic tighter than shift
10 - 3 - 2               // (10 - 3) - 2 = 5 — left-associative
s ^ 0x0F ^ 0x30          // (s ^ 0x0F) ^ 0x30
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
