
include "libc/ctypes64"
@c_include "math.h"
include "libc/math"
@c_include "stdlib.h"
include "libc/stdlib"
@c_include "stdio.h"
include "libc/stdio"


type Point record {
	x: Float
	y: Float
}

type Line record {
	a: Point
	b: Point
}


var line: Line = {
	a = {x = 0, y = 0}
	b = {x = 1.0, y = 1.0}
}




func max(a: Float, b: Float) -> Float {
	if a > b {
		return a
	}
	return b
}



func min(a: Float, b: Float) -> Float {
	if a < b {
		return a
	}
	return b
}
// Pythagorean theorem
func distance(a: Point, b: Point) -> Float {
	let dx = max(a.x, b.x) - min(a.x, b.x)
	let dy = max(a.y, b.y) - min(a.y, b.y)
	let dx2 = pow(dx, 2)
	let dy2 = pow(dy, 2)
	return sqrt(dx2 + dy2)
}


func lineLength(line: Line) -> Float {
	return distance(line.a, line.b)
}


func ptr_example() -> Unit {
	let ptr_p = malloc(sizeof(Point))

	// access by pointer
	ptr_p.x = 10
	ptr_p.y = 20

	printf("point(%f, %f)\n", ptr_p.x, ptr_p.y)
}


public func main() -> Int {
	// by value
	let len = lineLength(line)
	printf("line length = %f\n", len)

	ptr_example()

	return 0
}

