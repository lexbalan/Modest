// test/1.hello_world/src/main.cm

include "libc/ctypes64"
include "libc/stdio"

let hello = "Hello"
let world = "World!"

let hello_world = hello + " " + world


public func main() -> Int {
	printf("%s\n", *Str8 hello_world)
	return 0
}

