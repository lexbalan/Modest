# Variable Definition

Creates mutable storage bound to an [identifier](../identifier.md).

## Form

```
var <#identifier#>: <#type_expression#>                              // no initializer
var <#identifier#> = <#value_expression#>                            // inferred type
var <#identifier#>: <#type_expression#> = <#value_expression#>       // both
var <#id1#>, <#id2#>, ... : <#type_expression#>                      // several variables of one type
```

## Semantics

- With both type and initializer, the initializer is implicitly
  [constructed](../value/cons.md) to the declared type.
- With an initializer only, the variable takes the initializer's type. If the
  initializer is a generic literal, the *default* concrete type is selected:
  `Integer` → target `Int`, `Rational` → target `Float`, string → target
  `Str` (configurable per target, see `cfg/*.toml`).
- **Initialization.** A *global* variable without an initializer is
  zero-initialized (static storage). A *local* variable without an
  initializer must be assigned before first use — reading it is a
  compile-time error (`attempt to use an uninitialized value`). To
  zero-initialize explicitly, use `= 0`, `= []` (arrays), `= {}`
  (records).
- A global initializer must be a compile-time expression. Local initializers
  may be arbitrary runtime values.
- `public` global variables may be disabled by target configuration
  (`public_vars_forbidden`); prefer accessor functions in libraries.

## Examples

```modest
var x: Int16                   // global: zero-initialized
var y = 10                     // Integer literal -> target Int
var z: Int32 = 20
var r, g, b: Nat8              // three variables of one type

func main () -> Int {
	var local: Int32           // reading it now would be a compile error
	local = 5                  // assigned before use: ok

	printf("%hd %d %d %d\n", x, y, z, local)
	return 0
}
```
