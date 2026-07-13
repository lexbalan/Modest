# While Statement

Repeats its body while a `Bool` condition holds. `while` is the only loop
construct in Modest (there is no `for`).

## Form

```
while <#condition#> {
	<#statements#>
}
```

## Semantics

- The condition has type `Bool` and is evaluated before each iteration.
- `while true { ... }` is the idiomatic infinite loop.
- Iteration is controlled with [`break` and `again`](./break_again.md).

## Examples

```modest
// counted loop
var i: Nat32 = 0
while i < 10 {
	printf("%u\n", i)
	++i
}
```

```modest
// loop with early exit
while true {
	let c = getchar()
	if c == EOF {
		break
	}
	putchar(c)
}
```
