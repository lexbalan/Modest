
@c_include "stdio.h"

const hello = "Hello"
const world = "World"
const party_corn = "🎉"

const greeting = hello + " " + world//+ " " + party_corn


const test = "test"


public func main() -> ctypes64.Int {
	stdio.printf("%s\n", *Str8 greeting)

	if test == "test" {
		stdio.printf("test ok.\n")
	} else {
		stdio.printf("test failed.\n")
	}

	return 0
}

