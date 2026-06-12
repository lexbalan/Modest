# Field Access

Reads or writes a field of a record.

## Form

```
<#record_value#>.<#field#>
<#pointer_to_record#>.<#field#>      // auto-deref
```

## Semantics

- Works as an rvalue (read) and as an lvalue (assignment target).
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
pt.x = 10                     // lvalue
let sum = pt.x + pt.y         // rvalue

var pp: *Point = &pt
pp.y = 20                     // auto-deref
```

## See also

- [Record type](../type/record.md), [Index](./_index.md)
