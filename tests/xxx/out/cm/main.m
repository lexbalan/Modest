include "stdio"



/*@deprecated*/
type Point = record {
	x: Int32 = 32
	y: Int32 = 32
}


@deprecated
const mY = 5


@used
func returnPoint () -> Point {
	var p: Point
	p.x = 10
	return p
}

public func main () -> Int32 {
	printf("Hello World!\n")
	var p: Point = {}
	p = {}
	mY

	//var a: []Int64
	var b: Int64
	var c: Int32
	//a = a * b + c
	//offsetof(Point.y)
	//p.z
	//a = (2 + 2)
	//var j: jey.Jey
	return 0
}

