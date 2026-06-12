# Values

A *value expression* computes a value. Expressions are built from
literals, names and the operations below.

```
values
├── literal     42, 3.14, "abc", [1,2], {x=1}, true, nil ... literal.md
├── cons        TargetType value — construction ............ cons.md
├── binary      + - * / % == < and or & | ^ << >> .......... binary.md
├── unary       not ~ - + & * new .......................... unary.md
├── access      record.field ............................... access.md
├── index       arr[i] ..................................... _index.md
├── slice       arr[i:j] ................................... slice.md
├── call        f(args) .................................... call.md
└── sizeof      sizeof / alignof / lengthof / offsetof ..... sizeof.md
```

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

Binding examples (lower level = binds tighter):

```modest
w & mask == 0            // (w & mask) == 0   — bitwise tighter than ==
a == 1 and b == 2        // (a == 1) and (b == 2)
x + 1 < y << 2           // (x + 1) < (y << 2)
```

## Value categories

- **Immediate** — known at compile time: literals, `const`, and any
  expression over immediate operands (folded by the compiler).
- **Immutable** — not assignable: immediates, `let` bindings, function
  parameters. Taking the address of an immutable value is an error
  (`expected mutable value or function`).
- **Zero value** — `0` / `[]` / `{}`; globals without an initializer
  hold the zero value of their type.
