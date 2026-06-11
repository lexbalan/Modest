# Function Type

The type of a function: its parameter list and return type.

## Form

```
(<#parameters#>) -> <#return_type#>      // function type
*(<#parameters#>) -> <#return_type#>     // pointer to function
```

```modest
() -> Unit
(a: Int32, b: Int32) -> Int32
*(payload: Ptr) -> Unit                  // pointer to function
```

## Semantics

- A variable, parameter or record field cannot have a function type —
  only a *pointer to function*.
- `&f` yields a pointer to function `f`; the pointer is called with the
  ordinary call syntax.
- Parameter names are part of the notation but not of compatibility;
  default values and `...` are allowed as in
  [function definitions](../def/func.md).

## Examples

```modest
type Handler = *(payload: Ptr) -> Unit

func on_event (payload: Ptr) -> Unit {
	printf("event!\n")
}

var handler: Handler = &on_event

func main () -> Int {
	handler(nil)              // call through pointer
	return 0
}
```

## See also

- [Function definition](../def/func.md)
- [Call](../value/call.md)
