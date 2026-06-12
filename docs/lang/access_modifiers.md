# Access Modifiers

`public` and `private` control whether a definition is visible to
importing modules.

## Form

```
public <#definition#>
private <#definition#>
<#definition#>            // default
```

## Semantics

A definition without a modifier gets the internal *default* access,
resolved by context:

- module-level definitions: default → `private`
  (→ `public` if the module has `pragma public_module`);
- named record fields: default → `private`
  (→ `public` if the record type has the `@public` annotation);
- anonymous record fields: default → `public`.

Enforcement is **per module**: `private` restricts importers only;
inside the defining module everything is accessible.

Consequences in output: `public` symbols of module `m` are emitted with
the prefix `m_`; `private` symbols keep their name (and become `static`
in C). `@extern` suppresses the prefix entirely
(see [import](./import.md), [annotations](./attribute.md)).

## Examples

```modest
public func api () -> Unit { ... }     // visible to importers, emits m_api
func helper () -> Unit { ... }         // private by default

public type Point = @public {          // type and its fields public
	x: Float64
	y: Float64
}

type Conn = {
	fd: Int                            // private field: hidden from importers
	public state: Nat8                 // explicitly public field
}
```

## See also

- [Definitions](./def/README.md), [Record type](./type/record.md)
