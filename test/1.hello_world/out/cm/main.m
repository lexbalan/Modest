
include "libc/ctypes64"
include "libc/stdio"
const hello = "Hello"
const world = "World!"
const hello_world = hello + " " + world
func main() -> Int {
	printf("%s\n", *Str8 hello_world)
	return 0
}

