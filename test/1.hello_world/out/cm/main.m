
include "libc/ctypes64"
include "libc/stdio"
let hello = "Hello"
let world = "World!"
let hello_world = hello + " " + world
func main() -> Int {
	printf("%s\n", *Str8 hello_world)
	return 0
}

