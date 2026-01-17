// tests/xxx/src/main.m

include "libc/stdio"

type Point = @deprecated record {
	x: Int32
	y: Int32
}

@deprecated
const mY = 5

func returnPoint () -> Point {
	var p: Point
	p.x = 10
	return p
}

public func main () -> Int32 {
	printf("Hello World!\n")
	var p: Point = {x=0, y=0}
	mY

	var a: Int64
	var b: Int64
	var c: Int32
	a = a * b + c
	offsetof(Point.y)
	return 0
}

