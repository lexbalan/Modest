
@c_include "stdio.h"

const hello = "Hello"
const world = "World!"

const hello_world = hello + " " + world


public func main() -> Int {
	printf("%s\n", *Str8 hello_world)
	return 0
}

