# Statements

A *statement* is an instruction executed for its effect. Statements appear
inside function bodies and are executed sequentially.

| Statement | Form | Page |
|-----------|------|------|
| Variable definition | `var x: T = v` | [var](./var.md) |
| Immutable binding | `let x = v` | [let](./let.md) |
| Local type definition | `type T = ...` | [def/type](../def/type.md) |
| Nested function | `func f (...) -> T {}` | [def/func](../def/func.md) |
| Assignment | `lvalue = v` | [assign](./assign.md) |
| Increment / decrement | `++x`, `--x` | [assign](./assign.md) |
| Conditional | `if c {} else {}` | [if](./if.md) |
| Loop | `while c {}` | [while](./while.md) |
| Loop control | `break`, `again` | [break / again](./break_again.md) |
| Return | `return v` | [return](./return.md) |
| Value evaluation | `f(x)` | [eval](./eval.md) |
| Inline assembly | `__asm(...)` | [asm](./asm_inline.md) |

## Separators

Statements are separated by newlines. A semicolon may be used to put
several statements on one line:

```modest
var a: Int32 = 1; var b: Int32 = 2
```

## Notes

- Statements are not expressions: assignment, `++`/`--` and definitions
  produce no value and cannot appear inside expressions.
- A bare `{ ... }` is **not** a statement; braces delimit the bodies of
  `func`, `if` and `while` only (see [block](./block.md)).
