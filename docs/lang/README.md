# Modest Language Reference

The reference mirrors the structure of the language. One page — one
construct: Form, Semantics, Examples.

```
language
├── lexical
│   ├── comments        // and /* */ ................. comments.md
│   ├── identifiers     Type / value naming .......... identifier.md
│   └── fields          name: Type ................... fields.md
│
├── module
│   ├── import, include namespaces, C bindings ....... import.md
│   ├── pragmas         unsafe, prefix, c_include .... directive.md
│   ├── access          public / private / default ... access_modifiers.md
│   └── builtin         builtin.target.*, compiler ... builtin_constants.md
│
├── def                 const, var, func, type ....... def/
├── stmt                if, while, break/again, let,
│                       assign, return, asm .......... stmt/
├── type                base, generic, array, record,
│                       pointer, function, branded ... type/
├── value               literals, construction,
│                       operators, call, index ....... value/
│
├── annotations         @inline, @layout, @extern .... attribute.md
└── variadic            __VA_List, __va_start ........ va_arg.md
```

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
