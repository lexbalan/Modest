# Fields

A *field* pairs a name with a type and, optionally, a value. Fields are
the building blocks of definitions (`var`, `const`, `let`), function
parameters and record types.

## Form

```
<#identifier#>: <#type_expression#>
<#identifier#>: <#type_expression#> = <#value_expression#>
<#identifier#> = <#value_expression#>                        // type inferred
```

## Semantics

- The name is a value identifier, the type is any type expression.
- The meaning of `= value` depends on the context:
  - in `var` / `const` / `let` — the initializer
    (see [var](./def/var.md), [const](./def/const.md), [let](./stmt/let.md));
  - in a record type — overrides the field's default value: by default
    it is the default value of the field's type (`false` / `0` / `nil` /
    `{}` / `[]`), used when [construction](./value/cons.md) omits the
    field;
  - in function parameters — the default argument, the caller may omit
    it (see [func](./def/func.md)).
- In records and parameter lists fields are separated by commas or
  newlines; one name per field. Only `var` accepts a name list
  (`var x, y: Int32`).

## Examples

```modest
var counter: Int32 = 0                     // initializer

type P = {x: Float64 = 1.5, y: Float64}    // default for x

func scale (v: Float64, k: Float64 = 2.0) -> Float64 {
	return v * k                           // k defaults to 2.0
}
```

## See also

- [Identifiers](./identifier.md), [Record type](./type/record.md)
