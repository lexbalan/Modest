include "ctypes64"
include "stdio"
// tests/string_concat_eq/src/main.m

const hello = "Hello"
const world = "World"
const party_corn = "🎉"

const greeting = hello + " " + world//+ " " + party_corn


const test = "test"


public func main () -> Int {
	printf("%s\n", *Str8 greeting)

	if test == "test" {
		printf("test ok.\n")
	} else {
		printf("test failed.\n")
	}

	return 0
}

