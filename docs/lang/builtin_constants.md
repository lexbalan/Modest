# Built-in constants

```zig
import "libc/stdio"

public func main () -> Int {
	// __compiler
	printf("__compiler.name = %s\n", *Str8 __compiler.name)
	let ver = __compiler.version
	printf("__compiler.version.major = %u\n", ver.major)
	printf("__compiler.version.minor = %u\n", ver.minor)

	// __target
	printf("__target.name = %s\n", *Str __target.name)
	printf("__target.pointerWidth = %u\n", __target.pointerWidth)
	printf("__target.charWidth = %u\n", __target.charWidth)
	printf("__target.intWidth = %u\n", __target.intWidth)
	printf("__target.floatWidth = %u\n", __target.floatWidth)

	return 0
}

```
