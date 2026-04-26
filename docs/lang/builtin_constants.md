# Built-in constants

```zig
// tests/builtin_constants/src/main.m

include "libc/ctypes64"
include "libc/stdio"


func main () -> Int {

	// builtin.compiler
	printf("builtin.compiler.name = %s\n", *Str8 builtin.compiler.name)
	let ver = builtin.compiler.version
	printf("builtin.compiler.version.major = %u\n", ver.major)
	printf("builtin.compiler.version.minor = %u\n", ver.minor)

	// builtin.target
	printf("builtin.target.name = %s\n", *Str builtin.target.name)
	printf("builtin.target.pointerWidth = %u\n", builtin.target.pointerWidth)
	printf("builtin.target.charWidth = %u\n", builtin.target.charWidth)
	printf("builtin.target.intWidth = %u\n", builtin.target.intWidth)
	printf("builtin.target.floatWidth = %u\n", builtin.target.floatWidth)

	return 0
}

```
