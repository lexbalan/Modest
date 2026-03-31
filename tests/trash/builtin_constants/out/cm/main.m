import "builtin"
include "ctypes64"
include "stdio"



public func main () -> Int {
	printf("builtin.compiler.name = %s\n", *Str8 builtin.compiler.name)
	let ver = builtin.compiler.version
	printf("builtin.compiler.version.major = %u\n", ver.major)
	printf("builtin.compiler.version.minor = %u\n", ver.minor)

	printf("builtin.compiler.version.major = %u\n", builtin.compiler.version.major)
	printf("builtin.compiler.version.minor = %u\n", builtin.compiler.version.minor)
	printf("builtin.target.name = %s\n", *Str builtin.target.name)
	printf("builtin.target.pointerWidth = %u\n", builtin.target.pointerWidth)
	printf("builtin.target.charWidth = %u\n", builtin.target.charWidth)
	printf("builtin.target.intWidth = %u\n", builtin.target.intWidth)
	printf("builtin.target.floatWidth = %u\n", builtin.target.floatWidth)

	return 0
}

