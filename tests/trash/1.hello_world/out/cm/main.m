include "ctypes64"
include "stdio"


const hello = "Hello"
const world = "World!"

//const hello_world = hello + " " + world
const hello_world = "Hello World!"


public func main () -> Int {
	printf("%s\n", *Str8 hello_world)
	return 0
}

