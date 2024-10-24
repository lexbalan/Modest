// test/10.const/src/main.cm

include "libc/ctypes64"
include "libc/stdio"
include "libc/math"

$pragma c_include "./minmax.h"

include "misc/minmax"


type Point record {
	x: Float64
	y: Float64
}

type Line record {
	a: Point
	b: Point
}

let zero = 0
let pointZero = Point {x = zero, y = zero}
let pointOne = Point {x = 1.0, y = 1.0}

let line0 = Line {
	a = pointZero
	b = pointOne
}

let carr = [0, 10, 15] + [20, 25, 30]

let line1 = Line {
	a={x=10, y=20}
	b={x=30, y=40}
}


let line2 = Line {
	a = pointZero
	b = pointOne
}

let line3 = Line {
	a={x=10, y=20}
	b={x=30, y=40}
}

let lines = [line0, line1, line2, line3]


// Pythagorean theorem
func distance(a: Point, b: Point) -> Float {
	let dx = max_float64(a.x, b.x) - min_float64(a.x, b.x)
	let dy = max_float64(a.y, b.y) - min_float64(a.y, b.y)
	let dx2 = pow(dx, 2)
	let dy2 = pow(dy, 2)
	return sqrt(dx2 + dy2)
}


func lineLength (line: Line) -> Float {
	return distance(line.a, line.b)
}


public func main() -> Int {
	let lines_0_len = lineLength(lines[0])
	let lines_1_len = lineLength(lines[1])
	let lines_2_len = lineLength(lines[2])
	let lines_3_len = lineLength(lines[3])

	printf("lines_0_len = %f\n", lines_0_len)
	printf("lines_1_len = %f\n", lines_1_len)

	return 0
}


