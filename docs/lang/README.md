# Modest Language Reference

The reference mirrors the structure of the language. One page — one
construct: Form, Semantics, Examples.

### Lexical

| Construct | Form | Page |
| :-- | :-- | :-- |
| Comments | `//`, `/* */` | [comments](./comments.md) |
| Identifiers | `Type` / `value` naming | [identifier](./identifier.md) |
| Literals | `42`, `3.14`, `"abc"`, `true`, `nil` | [value/literal](./value/literal.md) |

### Module

| Construct | Form | Page |
| :-- | :-- | :-- |
| Imports | `import`, `include` — namespaces, C bindings | [import](./import.md) |
| Pragmas | `pragma unsafe`, `prefix`, `c_include` | [directive](./directive.md) |
| Access | `public` / `private` / default | [access_modifiers](./access_modifiers.md) |
| Builtin constants | `builtin.target.*` (incl. `rationalPrecision`), compiler info | [builtin_constants](./builtin_constants.md) |

### Core

| Section     | Contents                                                     | Page                        |
| :---------- | :----------------------------------------------------------- | :-------------------------- |
| Fields      | `name: Type` — building block of defs, params, records       | [fields](./fields.md)       |
| Definitions | `const`, `var`, `func`, `type`                               | [def/](./def/README.md)     |
| Statements  | `if`, `while`, `break`/`again`, `let`, assign, `return`, asm | [stmt/](./stmt/README.md)   |
| Types       | base, generic, array, record, pointer, function, branded     | [type/](./type/README.md)   |
| Values      | literals, construction, operators, call, index               | [value/](./value/README.md) |

### Misc

| Construct | Form | Page |
| :-- | :-- | :-- |
| Annotations | `@inline`, `@layout`, `@extern`, ... | [attribute](./attribute.md) |
| Variadic functions | `__VA_List`, `__va_start` | [va_arg](./va_arg.md) |

## Quick example

```modest
include "libc/stdio"

type Celsius = @branded Float64

const boiling = Celsius 100.0

func describe (t: Celsius) -> Unit {
	if t >= boiling {
		printf("steam\n")
	} else {
		printf("liquid or ice\n")
	}
}

func main () -> Int {
	describe(Celsius 36.6)
	return 0
}
```

For a one-page overview see the [cheatsheet](../CHEATSHEET.md).
