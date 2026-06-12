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

## Warning: large array copied by value

Arrays are ordinary value types (passed / returned / assigned by
value — no decay). On small embedded targets a silent copy of a large
array is a stack hazard. Idea (2026-06-12): emit a warning when an
array larger than a threshold is passed or returned by value:

```
warning: array of 4096 bytes passed by value (threshold 256);
         consider *[N]T
```

- threshold configurable per target in `cfg/*.toml`
  (e.g. `byvalue_copy_warn = 256`; embedded configs set it low);
- suppressible per call/definition, e.g. with `@unused`-style
  annotation or an explicit construction.

(Related but rejected for now: RVO-style lowering of array returns to
write directly into `__out` — deliberately left to the C optimizer.)

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
