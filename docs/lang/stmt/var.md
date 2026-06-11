# Var Statement

Defines a local variable. Forms and type inference rules are the same as
for the [module-level variable definition](../def/var.md):

```
var <#identifier#>: <#type_expression#>
var <#identifier#> = <#value_expression#>
var <#identifier#>: <#type_expression#> = <#value_expression#>
var <#id1#>, <#id2#>, ... : <#type_expression#>
```

## Local specifics

- A local variable without an initializer holds an **indeterminate**
  value — assign before use (globals, by contrast, are zero-initialized).
- The initializer may be any runtime expression.
- The variable is visible from its definition to the end of the enclosing
  block.

## Example

```modest
func main () -> Int {
	var flag: Bool = false
	var counter: Int32 = 0
	var x, y: Float64           // indeterminate until assigned

	x = 1.0
	y = 2.0
	Unit flag; Unit counter     // discard (suppress unused warnings)
	printf("%f\n", x + y)
	return 0
}
```
