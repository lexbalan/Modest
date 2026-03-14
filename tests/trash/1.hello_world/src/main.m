// tests/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"

const hello = "Hello"
const world = "World!"

//const hello_world = hello + " " + world
const hello_world = "Hello World!"


public func main () -> Int {
	printf("%s\n", *Str8 hello_world)
	return 0
}

