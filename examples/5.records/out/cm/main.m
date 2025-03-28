include "ctypes64"
include "math"
include "stdlib"
include "stdio"



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
	let dx2 = math.pow(dx, 2)
	let dy2 = math.pow(dy, 2)
	return math.sqrt(dx2 + dy2)
}


func lineLength(line: Line) -> Float {
	return distance(line.a, line.b)
}


func ptr_example() -> Unit {
	let ptr_p = stdlib.malloc(sizeof(Point))

	// access by pointer
	ptr_p.x = 10
	ptr_p.y = 20

	stdio.printf("point(%f, %f)\n", ptr_p.x, ptr_p.y)
}


public func main() -> Int {
	// by value
	let len = lineLength(line)
	stdio.printf("line length = %f\n", len)

	ptr_example()

	return 0
}

