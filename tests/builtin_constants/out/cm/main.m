include "ctypes64"
include "stdio"
// tests/builtin_constants/src/main.m


public func main () -> Int {

	// __compiler
	printf("__compiler.name = %s\n", *Str8 {name = "m2", version = {major = 0, minor = 7}}.name)
	let ver = {name = "m2", version = {major = 0, minor = 7}}.version
	printf("__compiler.version.major = %u\n", ver.major)
	printf("__compiler.version.minor = %u\n", ver.minor)

	// __target
	printf("__target.name = %s\n", *Str {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.name)
	printf("__target.pointerWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.pointerWidth)
	printf("__target.charWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.charWidth)
	printf("__target.intWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.intWidth)
	printf("__target.floatWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.floatWidth)

	return 0
}

