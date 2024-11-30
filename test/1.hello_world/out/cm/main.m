
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"
const hello = "Hello"
const world = "World!"
const hello_world = hello + " " + world


type Rec0 record {
	p: *Rec1
}

type Rec1 record {
	p: *Rec0
}
public func main() -> Int {
	printf("%s\n", *Str8 hello_world)

	var r0: Rec0
	var r1: Rec1

	r0.p = &r1
	r1.p = &r0

	return 0
}

