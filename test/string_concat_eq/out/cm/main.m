
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"

const hello = "Hello"
const world = "World"
const party_corn = "🎉"

const greeting = hello + " " + world


const test = "test"


public func main() -> Int {
	printf("%s\n", *Str8 greeting)

	if test == "test" {
		printf("test ok.\n")
	} else {
		printf("test failed.\n")
	}

	return 0
}

