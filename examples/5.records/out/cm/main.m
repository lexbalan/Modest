
@c_include "math.h"
@c_include "stdlib.h"
@c_include "stdio.h"


type Point record {
	x: ctypes64.Float
	y: ctypes64.Float
}

type Line record {
	a: Point
	b: Point
}


var line: Line = {
	a = {x = 0, y = 0}
	b = {x = 1.0, y = 1.0}
}




func max(a: ctypes64.Float, b: ctypes64.Float) -> ctypes64.Float {
	if a > b {
		return a
	}
	return b
}



func min(a: ctypes64.Float, b: ctypes64.Float) -> ctypes64.Float {
	if a < b {
		return a
	}
	return b
}


// Pythagorean theorem
func distance(a: Point, b: Point) -> ctypes64.Float {
	let dx = max(a.x, b.x) - min(a.x, b.x)
	let dy = max(a.y, b.y) - min(a.y, b.y)
	let dx2 = math.pow(dx, 2)
	let dy2 = math.pow(dy, 2)
	return math.sqrt(dx2 + dy2)
}


func lineLength(line: Line) -> ctypes64.Float {
	return distance(line.a, line.b)
}


func ptr_example() -> Unit {
	let ptr_p = stdlib.malloc(sizeof(Point))

	// access by pointer
	ptr_p.x = 10
	ptr_p.y = 20

	stdio.printf("point(%f, %f)\n", ptr_p.x, ptr_p.y)
}


public func main() -> ctypes64.Int {
	// by value
	let len = lineLength(line)
	stdio.printf("line length = %f\n", len)

	ptr_example()

	return 0
}

