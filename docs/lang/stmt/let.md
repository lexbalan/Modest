# Let Statement

Binds an identifier to a value, immutably. Allowed only inside function
bodies; the module-level analogue is [`const`](../def/const.md).

## Form

```
let <#identifier#> = <#value_expression#>
let <#identifier#>: <#type_expression#> = <#value_expression#>
```

## Semantics

- The initializer is **required** and may be any runtime expression
  (unlike `const`, which needs a compile-time value).
- The binding cannot be assigned to afterwards.
- One identifier per `let`.
- Without a type annotation the binding keeps the initializer's type,
  including generic literal types — `let n = 42` is a compile-time
  `Integer` that adapts at use sites, exactly like `const`.

## Examples

```modest
func mid (a: Int32, b: Int32) -> Int32 {
	let sum = a + b            // runtime value, type Int32
	let half: Int32 = sum / 2
	return half
}
```

```modest
let msg = *Str8 "ready\n"      // typed string pointer
printf(msg)
```
