# Identifiers

An identifier names a type or a value. The case of its first letter
decides which — lexically, before parsing.

## Form

```
'_'* <#lowercase_letter#> (<#letter#> | <#digit#> | '_')*    // value identifier
'_'* <#uppercase_letter#> (<#letter#> | <#digit#> | '_')*    // type identifier
```

## Semantics

- Letters are **ASCII Latin only**. Unicode characters are allowed only
  in [comments](./comments.md) and
  [string literals](./value/literal.md).
- The first letter (leading underscores are skipped) fixes the class:
  **lowercase** — value identifier (variables, constants, functions,
  parameters, fields, modules); **uppercase** — type identifier.
- The split is grammatical, not stylistic: where a type is expected only
  a type identifier parses, and vice versa. `var Xx: Int32` is a syntax
  error; a `type myInt = ...` definition parses, but the name can never
  appear in a type expression (`expected type expr`).
- Style: *PascalCase* for types, *camelCase* for values.

## Examples

```modest
type Point = {x: Float64, y: Float64}

const maxSize = 100
var counter: Int32

func doWork () -> Unit {
}

type _Handle = Int32     // underscores skipped: H decides the class
var _tmp: _Handle = 0
```

## See also

- [Definitions](./def/README.md), [Fields](./fields.md)
