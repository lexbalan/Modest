// tests/1.hello_world/src/main.m

include "libc/stdio"

type Point = record {
	x: Int32
	y: Int32
}

public func main () -> Int32 {
	printf("Hello World!\n")
	var p: Point = {x=0, y=0, z=0}
	return 0
}

