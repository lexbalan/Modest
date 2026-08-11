# Import & Include

Bring another module's public definitions into the current module —
under a namespace (`import`) or directly (`include`).

## Form

```
import <#"path"#> [as <#identifier#>]
include <#"path"#>
```

## Semantics

- `import "m"` — public definitions of `m` are accessed as `m.name`;
  `as x` renames the namespace to `x`.
- `include "m"` — public definitions enter the current namespace and
  are used unqualified. Idiomatic for C bindings (`libc/*`).
- Path resolution (`.modest` appended automatically; a legacy `.m` file
  is tried next, so unrenamed modules still resolve):
  1. paths starting with `./` or `../` — relative to the importing file;
  2. otherwise, the importing file's directory;
  3. otherwise, the library directory (`MODEST_LIB` / `-L`).
- A module is translated once; repeated imports reuse it. Recursive
  imports are an error (`recursive import detected`).
- In output, public symbols of an imported module get its name as a
  prefix (`utils_f`); `include`d modules keep original names
  (see [access modifiers](./access_modifiers.md)).

## Examples

```modest
include "libc/stdio"          // printf, unqualified
import "misc/sha256"          // namespace sha256
import "./engine" as eng      // relative path, renamed

func main () -> Int {
	var h: sha256.Hash
	sha256.hash(data, len, &h)
	eng.start()
	printf("done\n")
	return 0
}
```

## See also

- [Pragmas](./directive.md) — `pragma prefix`, `pragma do_not_include`
- [Access modifiers](./access_modifiers.md)
