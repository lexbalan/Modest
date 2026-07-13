# Field Access

Designates a field of a record. The expression denotes the field
itself — a *place*, not a copy of its value; what happens to it is
decided by the context: read, assignment target, or address-of
(`&pt.x`).

## Form

```
<#record_value#>.<#field#>
<#pointer_to_record#>.<#field#>      // auto-deref
```

## Semantics

- Usable as an rvalue (read), as an lvalue (assignment target), and as
  the operand of `&` — `&pt.x` is a pointer to the field. A field of a
  mutable record is mutable.
- Through a pointer the access dereferences automatically: `p.x`, never
  `(*p).x`.
- Access to a `private` field of a record type defined in *another*
  module is an error; inside the defining module all fields are
  accessible (see [access modifiers](../access_modifiers.md)).
- Field offset within the record: `offsetof(Type.field)`
  (see [sizeof](./sizeof.md)).

## Examples

```modest
type Point = {x: Int32, y: Int32}

var pt: Point = {x = 1, y = 2}
pt.x = 10                     // assignment target
let sum = pt.x + pt.y         // read
var px: *Int32 = &pt.x        // address of the field

var pp: *Point = &pt
pp.y = 20                     // auto-deref
```

## See also

- [Record type](../type/record.md), [Index](./_index.md)
