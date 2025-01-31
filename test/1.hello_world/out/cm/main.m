
@c_include "stdio.h"

const hello = "Hello"
const world = "World!"

const hello_world = hello + " " + world


public func main() -> ctypes64.Int {
	stdio.printf("%s\n", *Str8 hello_world)
	return 0
}

