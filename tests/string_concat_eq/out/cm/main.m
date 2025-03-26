
@c_include "stdio.h"

const hello = "Hello"
const world = "World"
const party_corn = "🎉"

const greeting = hello + " " + world//+ " " + party_corn


const test = "test"


public func main() -> Int {
	stdio.("%s\n", *Str8 greeting)

	if test == "test" {
		stdio.("test ok.\n")
	} else {
		stdio.("test failed.\n")
	}

	return 0
}

