
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"
const hello = "Hello"
const world = "World!"
const hello_world = hello + " " + world
public func main() -> Int {
	printf("%s\n", *Str8 hello_world)
	return 0
}
