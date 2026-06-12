# Design TODO

## Zero-terminated strings via `@zarray`

Design intent (Alex, 2026-06-11):

- A string literal contains **exactly** the characters written — no
  implicit terminator.
- The terminator appears at *construction* of a zero-terminated array.
  `@zarray` marks an array type as zero-terminated; constructing a value
  of such type appends the terminator.
- The built-in string types should carry the attribute:

  ```modest
  type Str8  = @zarray []Char8
  type Str16 = @zarray []Char16
  type Str32 = @zarray []Char32
  ```

- Consequences:
  - `*Str8 "xxx"` → array of 4 chars (terminator appended by
    construction);
  - `[]Char8 "xxx"` → array of exactly 3 chars, **no** terminator.

Status: the `@zarray` annotation is recognized by the compiler
(`hlir/types.py`), but the built-in `Str*` types do not carry it yet;
zero-termination currently comes from the C backend emitting C string
literals. To be implemented.

## Conditional compilation (`$`-directives)

Historical design, currently not implemented (the lexer tokenizes
`$name`, the parser rejects it at top level):

```
$if (<#immediate Bool#>)
	...
$elseif (<#immediate Bool#>)
	...
$else
	...
$endif
```

Companions from the same design: `__defined("id")`, `@undef("id")`,
compiler messages `@info` / `@warning` / `@error`, `@feature("unsafe")`.
Removed from `docs/lang/directive.md` (which now documents pragmas)
until reimplemented.
