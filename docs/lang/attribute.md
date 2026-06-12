# Annotations

An *annotation* (attribute) attaches metadata to a definition or a type
expression and influences translation.

## Form

```
@<#name#>
@<#name#>(<#arguments#>)
```

Annotations are written before a definition, or inside a type expression
(qualifying the type to the right of them).

## Reference

### Inlining

| | |
| :-- | :-- |
| `@inline` | request inlining |
| `@inlinehint` | weak inlining hint |
| `@noinline` | forbid inlining |

### Linkage & C interop

| | |
| :-- | :-- |
| `@extern` | external symbol, no module prefix |
| `@extern("C", "name")` | link to a specific C symbol |
| `@alias("name")` | output symbol name (C and LLVM) |
| `@alias("c"\|"llvm", "name")` | per-backend output name |
| `@cbyvalue` | pass record by value in the C ABI |
| `@nonstatic` | suppress `static` in C output |
| `@no_print`, `@c_no_print`, `@ll_no_print` | omit the definition from output (both / C / LLVM) |

### Diagnostics & lifetime

| | |
| :-- | :-- |
| `@used` | keep symbol even if unreferenced |
| `@unused` | suppress unused warnings (also on return types: `-> @unused Int`) |
| `@deprecated` | warn at use sites |

### Type layout & memory

| | |
| :-- | :-- |
| `@layout("packed"\|"union"\|"exact")` | record layout |
| `@alignment(N)` | alignment in bytes |
| `@volatile` | volatile qualifier |
| `@const` | const qualifier |
| `@restrict` | restrict qualifier |
| `@section("name")` | linker section |
| `@branded` | nominal type (see [branded](./type/branded.md)) |
| `@zarray` | zero-terminated array (see `docs/TODO.md`) |
| `@fraction(N)` | binary point for `FixedX` |

### Access

| | |
| :-- | :-- |
| `@public` | on a record type: default-access fields become public |

## Examples

```modest
@inline
func min (a: Int32, b: Int32) -> Int32 {
	if a < b { return a }
	return b
}

@extern("C", "malloc")
func myAlloc (size: Nat64) -> Ptr

@used @section("__DATA,.table")
var table: [256]Word8 = []

type Packet = @layout("packed") {
	tag: Word8
	len: Nat32
}

var uartByte: @volatile Word8
```

## See also

- [Pragmas](./directive.md) — module-level directives
- [Type definitions](./def/type.md)
