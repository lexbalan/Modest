include "ctypes64"
include "stdio"



public func main () -> Int {

	// __compiler
	printf("__compiler.name = %s\n", *Str8 *Str8 {name = "m2", version = {major = 0, minor = 7}}.name)
	let ver = {name = "m2", version = {major = 0, minor = 7}}.version
	printf("__compiler.version.major = %u\n", Nat32 ver.major)
	printf("__compiler.version.minor = %u\n", Nat32 ver.minor)

	printf("__compiler.version.major = %u\n", Nat32 {name = "m2", version = {major = 0, minor = 7}}.version.major)
	printf("__compiler.version.minor = %u\n", Nat32 {name = "m2", version = {major = 0, minor = 7}}.version.minor)

	// __target
	printf("__target.name = %s\n", *Str *Str {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.name)
	printf("__target.pointerWidth = %u\n", Nat32 {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.pointerWidth)
	printf("__target.charWidth = %u\n", Nat32 {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.charWidth)
	printf("__target.intWidth = %u\n", Nat32 {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.intWidth)
	printf("__target.floatWidth = %u\n", Nat32 {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.floatWidth)

	return 0
}

