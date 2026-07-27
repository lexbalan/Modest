# Function Definition

Binds an [identifier](../identifier.md) to a function with the given
[function type](../type/func.md) and body.

## Form

```
func <#identifier#> (<#parameters#>) -> <#return_type#> {
	<#statements#>
}
```

The return type is mandatory; use `Unit` for functions returning nothing.
A definition without a body is a *declaration* — it names an external
function and is normally combined with `@extern`.

## Parameters

Parameters are [fields](../fields.md): `name: Type`. Additionally:

- **Default values**: `name: Type = value`. The argument may then be omitted
  at the call site.
- **Named arguments**: any call may pass arguments by name:
  `f(b = 2, a = 1)` (see [call](../value/call.md)).
- **Variadic functions**: a trailing `...` accepts a C-style variable
  argument list (used for C interop, see [va_arg](../va_arg.md)).

```modest
func greet (name: *Str8 = "World") -> Unit { ... }

@extern("C")
public func printf (format: *Str8, ...) -> @unused Int
```

## Nested functions

A function may be defined inside another function. It is an ordinary
function whose name is local to the enclosing body — it does **not**
capture variables (no closures). Local `type` definitions are also allowed.

```modest
func main () -> Int {
	func twice (x: Int32) -> Int32 {
		return x * 2
	}
	return twice(21) - 42
}
```

## Experimental: signature from a named function type

```
func <#identifier#>: <#FuncType#> {
	<#statements#>
}
```

Instead of spelling out `(params) -> Return`, the parameter list and return
type can be borrowed from a predeclared [function type](../type/func.md).
Parameter names come from the type, so they don't need to be repeated at
every definition that shares the same shape:

```modest
type FailHandler = (code: Int32) -> Unit

func onDiskFail: FailHandler {
	printf("disk failed with code %d\n", code)
}

func onNetworkFail: FailHandler {
	printf("network failed with code %d\n", code)
}
```

`<#FuncType#>` must resolve to a function type — not a pointer to one.
The colon form and the inline `(params) -> Return` form cannot be mixed on
the same definition.

This syntax is experimental: useful for a handful of definitions that
repeat the exact same callback shape, but at the cost of hiding the
parameter list at the definition site — a reader must look up the type to
see what's being passed in. Prefer the inline form unless several
definitions genuinely share one signature.

## Notes

- The program entry point is `func main () -> Int`.
- A function's address is taken with `&name` and stored in a
  [pointer to function](../type/func.md).
- Inlining is controlled with `@inline` / `@inlinehint` / `@noinline`
  (see [annotations](../attribute.md)).

## Example

```modest
func sum (a: Int32, b: Int32) -> Int32 {
	return a + b
}

func main () -> Int {
	printf("%d\n", sum(10, 20))
	return 0
}
```
