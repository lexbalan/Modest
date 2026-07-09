# Record Type

A *record* is a composite type with named fields (`struct` in C).

## Form

```
{ <#field#>, <#field#>, ... }       // field: name: Type
```

```modest
{x: Int32, y: Int32}      // inline form

type Point = {            // newline-separated form
	x: Int32
	y: Int32
}
```

## Semantics

- Records are compared structurally; two record types with the same
  fields are compatible (see [README](./README.md)). `@branded` makes a
  record nominal.
- A record value is constructed from a record literal:
  `Point {x = 1, y = 2}` (explicit) or `p = {x = 1, y = 2}` (implicit
  when the target type is known). Fields omitted by the literal take
  their default value — the default value of the field's type
  (`false` / `0` / `nil` / `{}` / `[]`), unless overridden in the field
  declaration (`x: Float64 = 1.5`, see [fields](../fields.md));
  `{}` fills everything this way.
- Field access: `p.x`. Through a pointer the access auto-derefs:
  `pp.x` where `pp: *Point` (see [pointer](./pointer.md)).
- Records are assigned and passed **by value**; use `*Point` to share.
- Field offsets: `offsetof(Point.y)` (see [sizeof](../value/sizeof.md)).
- In a module-level `type` definition fields are **private** by default:
  visible inside the defining module, hidden from importers. Mark fields
  `public` individually, or put `@public` on the record to flip the
  default. Fields of anonymous records are always accessible
  (see [access modifiers](../access_modifiers.md)).
- Layout is controlled by annotations on the record type:
  - `@layout("packed")` — no padding;
  - `@layout("union")` — all fields at offset 0 (C union);
  - `@layout("exact")` — layout exactly as written.
- A field cannot have a function type; use a pointer to function
  (see [func](./func.md)).
- The last field may be a zero-length array (flexible array member);
  requires `-f unsafe`.

## Examples

```modest
public type Point = @public {
	x: Float64
	y: Float64
}

var p: Point = {x = 1.0, y = 2.0}
p.x = 3.0

type Color = @layout("union") {
	rgba: Word32
	components: {r: Nat8, g: Nat8, b: Nat8, a: Nat8}
}

type Header = @layout("packed") {
	tag: Word8
	len: Nat32          // offset 1, no padding
}
```

## See also

- [Field access](../value/access.md), [Value construction](../value/cons.md)
- [Branded types](./branded.md)
