
@c_include "stdio.h"


public func main() -> Int {

	// __compiler
	stdio.("__compiler.name = %s\n", *Str8 {name = "m2", version = {major = 0, minor = 7}}.name)
	let ver = {name = "m2", version = {major = 0, minor = 7}}.version
	stdio.("__compiler.version.major = %u\n", ver.major)
	stdio.("__compiler.version.minor = %u\n", ver.minor)

	// __target
	stdio.("__target.name = %s\n", *Str {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.name)
	stdio.("__target.pointerWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.pointerWidth)
	stdio.("__target.charWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.charWidth)
	stdio.("__target.intWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.intWidth)
	stdio.("__target.floatWidth = %u\n", {name = "Default", charWidth = 8, intWidth = 32, floatWidth = 64, pointerWidth = 64}.floatWidth)

	return 0
}

