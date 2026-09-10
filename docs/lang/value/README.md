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
and `&` `|` `^` `<<` `>>` want `WordX`, so a mixed chain is a type error,
not a grouping question.

Within the bitwise half the level is flat — none of `&`, `|`, `^` and the
shifts binds tighter than the others — and a chain that mixes two of them
is therefore **refused** rather than grouped:

```modest
let m = a | b & c        // error: required parentheses
let m = (a | b) & c      // one reading
let m = a | (b & c)      // the other, and they differ
```

Operators of the same kind chain freely, since there the grouping changes
nothing that needs deciding; `<<` and `>>` count as one kind:

```modest
s ^ 0x0F ^ 0x30          // (s ^ 0x0F) ^ 0x30
x >> 1 >> 2              // (x >> 1) >> 2
```

Because a mixed chain never compiles, no program can depend on how the
level orders itself — which is what leaves [QUESTION#5](../QUESTIONS.md)
open at no cost.

Level 3 is flat in the same way: two comparisons may not be chained without
parentheses either.

```modest
let ok = a == b < c      // error: required parentheses
let ok = a == b == c     // and so is a chain of equalities
```

The left-associative reading of such a chain always compares the `Bool` that
the first comparison produced — `(a == b) < c`, `(a == b) == c` — and that is
never what the line was meant to say. Ordering a `Bool` would not typecheck
anyway; comparing two of them would, which is exactly why the chain is
refused in the parser rather than left to the types.

Binding examples (lower level = binds tighter):

```modest
w & mask == 0            // (w & mask) == 0   — bitwise tighter than ==
a == 1 and b == 2        // (a == 1) and (b == 2)
w << 3 == 0x18           // (w << 3) == 0x18
w << n * 2               // w << (n * 2)      — `*` tighter than the shift
10 - 3 - 2               // (10 - 3) - 2 = 5  — left-associative
Word64 b << 8            // (Word64 b) << 8   — construction tighter still
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
