# Block

A *block* is a brace-delimited sequence of statements forming the body of
a [function](../def/func.md), [`if`](./if.md) branch or
[`while`](./while.md) loop.

```
{ <#statements#> }
```

## Semantics

- Statements execute in order, top to bottom.
- Names defined in a block (`var`, `let`, local `type`, nested `func`) are
  visible from their definition to the end of that block.
- A bare `{ ... }` is **not** a standalone statement — blocks exist only
  as bodies of the constructs above.

## Example

```modest
func main () -> Int {
	var x: Int32 = 1          // visible to end of function
	if x > 0 {
		let y = x * 2         // visible to end of this branch
		printf("%d\n", y)
	}
	return 0
}
```
