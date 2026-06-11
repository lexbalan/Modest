# If Statement

Executes one of its branches depending on a `Bool` condition.

## Form

```
if <#condition#> {
	<#statements#>
}

if <#condition#> {
	...
} else {
	...
}

if <#condition1#> {
	...
} else if <#condition2#> {
	...
} else {
	...
}
```

## Semantics

- The condition is an expression of type `Bool`; there is no implicit
  conversion from numbers or pointers — write `x != 0`, `p != nil`.
- Parentheses around the condition are not required.
- Braces are mandatory for every branch.
- `else if` chains may be arbitrarily long; the final `else` is optional.

## Example

```modest
if a > b {
	printf("a > b\n")
} else if a < b {
	printf("a < b\n")
} else {
	printf("a == b\n")
}
```
