private import "builtin"
include "ctypes64"
include "stdio"



func main () -> Int {
	printf("builtin.compiler.name = %s\n", *Str8 name)
	let ver = version
	printf("builtin.compiler.version.major = %u\n", ver.major)
	printf("builtin.compiler.version.minor = %u\n", ver.minor)
	printf("builtin.target.name = %s\n", *Str name)
	printf("builtin.target.pointerWidth = %u\n", pointerWidth)
	printf("builtin.target.charWidth = %u\n", charWidth)
	printf("builtin.target.intWidth = %u\n", intWidth)
	printf("builtin.target.floatWidth = %u\n", floatWidth)

	return 0
}

