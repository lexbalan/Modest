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

CRC-32 of a string — a checksum is what medium-level code is made of, and
it puts most of the language on one screen: bit work belongs to `Word*`,
widening is written out, an array is a value.

```modest
include "libc/ctypes64"
include "libc/stdio"

// CRC-32 (IEEE), one bit at a time — no table, no allocation.
func crc32 (data: *[]Byte, len: Size) -> Word32 {
	var crc: Word32 = 0xFFFFFFFF

	var i = Size 0
	while i < len {
		crc = crc ^ Word32 data[i]  // Byte widens by construction, not implicitly

		var bit = Nat8 0
		while bit < 8 {
			if crc & 1 != 0 {  // `&` binds tighter than `!=` — no C parens needed
				crc = crc >> 1 ^ 0xEDB88320
			} else {
				crc = crc >> 1
			}
			++bit
		}

		++i
	}

	return crc ^ 0xFFFFFFFF
}


func main () -> Int {
	var message: [9]Byte = "123456789"

	// An array is a value: `&message` is a pointer to it, nothing decays.
	printf("crc32 = %08x\n", crc32(*[]Byte &message, lengthof(message)))
	return 0
}
```

Prints `crc32 = cbf43926` — the standard CRC-32 check value.

For a one-page overview see the [cheatsheet](../CHEATSHEET.md).

Design decisions the language has not made yet are collected in
[open questions](./OPENQUESTIONS.md).
