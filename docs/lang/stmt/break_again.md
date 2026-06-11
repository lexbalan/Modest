# Break / Again

Loop control statements; both are valid only inside a
[`while`](./while.md) body.

## break

Exits the nearest enclosing loop immediately.

## again

Restarts the nearest enclosing loop: jumps back to the condition check
(`continue` in C).

There are no loop labels; `break` and `again` always refer to the
innermost loop.

## Example

```modest
var n: Int32 = 0
while true {
	scanf("%d", &n)
	if n < 0 {
		printf("enter a positive number: ")
		again
	}
	break          // got a valid value
}
```
