# Pointer Type

A *pointer* holds the address of a value of a known type.

## Form

```
*<#type_expression#>
```

```modest
*Int32        // pointer to Int32
**Int32       // pointer to pointer
*[]Char8      // pointer to open char array (string)
Ptr           // built-in alias for *Unit (free pointer)
```

## Semantics

- `&x` takes an address, `*p` dereferences (see
  [unary](../value/unary.md)). `nil` is the null pointer.
- **Auto-dereference:** pointers to records and arrays are dereferenced
  automatically on field access and indexing — `p.field`, `p[i]`;
  explicit `(*p)` is unnecessary.
- **No pointer arithmetic** — for any pointer type. Address computations
  are expressed by indexing: take `&a[i]` to point at an element, or
  reinterpret the pointer as a byte array first:

  ```modest
  let bytes = unsafe *[]Word8 p     // view memory as bytes
  let q = &bytes[4]                 // "p + 4"
  ```

- **Free pointer** `*Unit` (alias `Ptr`) accepts the address of a value
  of any type, but cannot be dereferenced or indexed. Construct a typed
  pointer from it first: `*Int64 freePtr` (safe), e.g. when receiving
  `Ptr` payloads in callbacks.
- Constructing one typed pointer from another of a different pointee
  type is a reinterpretation and requires `unsafe`
  (see [construction rules](../value/cons.md)).
- Pointer ↔ integer conversions are `unsafe`: `unsafe Nat64 p` for the
  address value.

## Examples

```modest
var a: Int32 = 0
var p: *Int32 = &a
*p = 10                       // a == 10

type Node = {next: *Node, data: Int32}
var n: Node = {next = nil, data = 1}
var pn: *Node = &n
pn.data = 2                   // auto-deref, no (*pn).data

func handler (payload: Ptr) -> Unit {
	let ctx = *Node payload   // typed view of a free pointer
	printf("%d\n", ctx.data)
}
```

## See also

- [Unary operations](../value/unary.md) — `&`, `*`
- [Function pointers](./func.md)
