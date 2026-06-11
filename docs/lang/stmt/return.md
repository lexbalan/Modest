# Return Statement

Stops execution of the current function and returns a value.

## Form

```
return <#value_expression#>    // function returns non-Unit
return                          // function returns Unit
```

## Semantics

- The value is implicitly [constructed](../value/cons.md) to the
  function's return type.
- In a `Unit` function, `return` takes no value and may be omitted at the
  end of the body.
- A non-`Unit` function should return a value on every path; a missing
  `return` at the end of the body is a compiler warning
  (`expected return operator at end`).

## Examples

```modest
func mid (a: Int32, b: Int32) -> Int32 {
	return (a + b) / 2
}

func log (enabled: Bool, msg: *Str8) -> Unit {
	if not enabled {
		return            // early exit
	}
	printf("%s\n", msg)
}
```
