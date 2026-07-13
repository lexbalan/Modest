# Call

Invokes a function — directly or through a pointer to function.

## Form

```
<#function#>(<#arguments#>)
<#pointer_to_function#>(<#arguments#>)
```

## Semantics

- Arguments are constructed implicitly to the parameter types
  (see [cons](./cons.md)).
- **Named arguments**: any argument may be passed as `name = value`,
  in any order; positional and named arguments may be mixed
  (`area(3, h = 4)`).
- Parameters with default values may be omitted
  (see [function definition](../def/func.md)).
- Variadic functions (`...`) accept extra arguments after the fixed
  ones, C-style.
- A pointer to function is called with the same syntax; the pointer
  variable must have type `*(...) -> T` (see [func](../type/func.md)).
- A call is an expression; calling a `Unit` function as a statement is
  the usual [value evaluation](../stmt/eval.md).

## Examples

```modest
func area (w: Int32, h: Int32 = 1) -> Int32 {
	return w * h
}

let a1 = area(3, 4)              // positional
let a2 = area(h = 4, w = 3)      // named, any order
let a3 = area(5)                 // default h = 1

type Op = *(a: Int32, b: Int32) -> Int32
func add (a: Int32, b: Int32) -> Int32 { return a + b }

var op: Op = &add
let s = op(1, 2)                 // call through pointer
```

## See also

- [Function definition](../def/func.md), [Function type](../type/func.md)
