include "ctypes64"
include "stdio"



public func main() -> Int {

	// __compiler
	stdio.printf("__compiler.name = %s\n", *Str8 {name = "m2", version = {major = 0, minor = 7}}.name)
	let ver = {name = "m2", version = {major = 0, minor = 7}}.version
	stdio.printf("__compiler.version.major = %u\n", ver.major)
	stdio.printf("__compiler.version.minor = %u\n", ver.minor)

	// __target
	stdio.printf("__target.name = %s\n", *Str {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.name)
	stdio.printf("__target.pointerWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.pointerWidth)
	stdio.printf("__target.charWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.charWidth)
	stdio.printf("__target.intWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.intWidth)
	stdio.printf("__target.floatWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.floatWidth)

	return 0
}

