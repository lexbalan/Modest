include "ctypes64"
include "stdio"
// tests/1.hello_world/src/main.m

const hello = "Hello"
const world = "World!"

const hello_world = hello + " " + world


public func main () -> Int {
	printf("%s\n", *Str8 hello_world)
	return 0
}

