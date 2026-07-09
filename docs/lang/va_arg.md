# Variadic Functions

`...` as the last parameter makes a function *variadic* (C varargs ABI).
The extra arguments are read through a `__VA_List` value and the
`__va_*` builtins.

## Form

```
func <#name#> (<#params#>, ...) -> <#type#>

var <#va#>: __VA_List
__va_start(<#va#>, <#last_named_param#>)
__va_arg(<#va#>, <#Type#>)                  // value of Type
__va_copy(<#dst#>, <#src#>)
__va_end(<#va#>)
```

## Semantics

- `__va_start` binds the list to the arguments after the last named
  parameter; `__va_end` releases it. One `__va_start` — one `__va_end`.
- `__va_arg(va, T)` is a value expression: it yields the next argument
  as a `T` and advances the list.
- The argument count and types are not checked — the callee must know
  them from elsewhere (a count parameter, a format string).
- A `__VA_List` may be passed on to C functions taking `va_list`
  (`vprintf`, `vsnprintf`, ...).
- `__va_copy` duplicates a list — but reading the copy is currently
  rejected (`attempt to use an uninitialized value`, see
  [BUGS](../BUGS.md) #7).
- Both backends support varargs: `c11` emits `<stdarg.h>` calls, `llvm`
  the corresponding intrinsics.

## Examples

```modest
include "libc/stdio"

// consume arguments in Modest
func sum (count: Int32, ...) -> Int32 {
	var va: __VA_List
	__va_start(va, count)

	var total: Int32 = 0
	var i: Int32 = 0
	while i < count {
		total = total + __va_arg(va, Int32)
		++i
	}

	__va_end(va)
	return total
}

// forward to a C v-function
func log (format: *Str8, ...) -> Unit {
	var va: __VA_List
	__va_start(va, format)
	vprintf(format, va)
	__va_end(va)
}

func main () -> Int {
	printf("%d\n", sum(3, 10, 20, 30))   // 60
	log("k = %d, s = %s\n", 42, "hi")
	return 0
}
```

## See also

- [Function definition](./def/func.md), [Function type](./type/func.md)
