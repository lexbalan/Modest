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

## Names reserved by the C backend

Symbol names are emitted into C as they are written (see
[Name Mapping](../CHEATSHEET.md#name-mapping-modest--c--llvm-ir)), so a
value identifier that happens to be a **C keyword** produces C that does
not compile:

```modest
func double (n: Int32) -> Int32 {     // -> int32_t double(int32_t n)
	return n * 2
}
```

```
error: cannot combine with previous 'type-name' declaration specifier
```

This is the price of readable, one-to-one C output — the backend does not
mangle or escape names, so what you write is what appears in the header
your C code includes. Avoid `double`, `float`, `switch`, `case`,
`default`, `union`, `struct`, `enum`, `register`, `signed`, `unsigned`,
`volatile`, `restrict`, `static`, `extern`, `goto`, `typedef`, `sizeof`
and the rest of the C keyword set as value identifiers. Reserved C
namespaces are worth avoiding for the same reason: a leading underscore at
file scope (`_tmp`) and anything starting with `str`/`mem` may collide
with the C standard library.

Only **value** identifiers are exposed to this: C keywords are all
lowercase, and a Modest type identifier must start with a capital letter,
so `type Union = ...` or `type Double = ...` is safe.

The **LLVM backend is unaffected** — identifiers there are sigil-prefixed
(`@double`, `%x`) and cannot collide with anything. A program that only
targets LLVM IR can use these names freely, at the cost of no longer
building with `-mbackend=c11`.

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
