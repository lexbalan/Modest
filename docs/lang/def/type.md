# Type Definition

Binds an [identifier](../identifier.md) to a [type](../type/README.md).

## Form

```
type <#identifier#> = <#type_expression#>
```

## Semantics

- The type system is *structural*: a defined name is an alias, fully
  compatible with its right-hand side and with any structurally equal type.
  To obtain a nominal (incompatible) type, add
  [`@branded`](../type/generic.md):

  ```modest
  type Meters = @branded Float64   // not mixable with plain Float64
  ```

- Recursive types need no forward declaration — all module-level type names
  are visible before definitions are processed:

  ```modest
  type Node = {
  	next: *Node
  	data: Ptr
  }
  ```

- Type definitions are allowed inside function bodies; the name is then
  local to the body.
- Layout and qualifiers are controlled with annotations on the right-hand
  side: `@layout("packed" | "union" | "exact")`, `@alignment(N)`,
  `@volatile`, `@const` (see [annotations](../attribute.md)).

## Examples

```modest
type MyInt = Int32
type CStr = *Char8
type Buffer = [256]Word8

type Point = {x: Int64, y: Int64}

type Color = @layout("union") {
	rgba: Word32
	r: Word8
}
```
