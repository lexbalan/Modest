# Pragmas

A *pragma* is a module-level directive: it configures translation of the
current module. Pragmas take effect from their position to the end of
the file.

## Form

```
pragma <#name#> [<#arguments#>]
```

## Reference

| Pragma | Effect |
| :-- | :-- |
| `pragma unsafe` | allow `unsafe` constructions in this module |
| `pragma public_module` | default access of definitions becomes `public` |
| `pragma prefix "p"` | output-symbol prefix for this module (empty string disables) |
| `pragma c_include "h.h"` | emit `#include "h.h"` in C output |
| `pragma do_not_include` | importers do not `#include` this module's header |
| `pragma c_no_print` | omit this module's definitions from C output |
| `pragma insert <#text#>` | insert text into output verbatim |

## Examples

```modest
// C binding module: no prefix, no own output
pragma prefix ""
pragma do_not_include

@extern("C")
public func write (fd: Int, buf: Ptr, n: Size) -> Size
```

```modest
pragma unsafe
pragma c_include "./sha256.h"

let bytes = unsafe *[]Word8 data
```

## `$`-directives

Tokens of the form `$name` are reserved for compiler directives
(conditional compilation, `$if` / `$else`); this mechanism is currently
**not implemented** — the historical design is kept in `docs/TODO.md`.

## See also

- [Annotations](./attribute.md) — per-definition metadata
- [Import](./import.md)
