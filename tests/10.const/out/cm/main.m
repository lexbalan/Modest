
@c_include "stdio.h"
@c_include "math.h"
@c_include "./minmax.h"
import "misc/minmax" as minmax


const carr = [0, 10, 15] + [20, 25, 30]


type Point record {
	x: Float64
	y: Float64
}

type Line record {
	a: Point
	b: Point
}

const zero = 0
const pointZero = Point {x = zero, y = zero}
const pointOne = Point {x = 1.0, y = 1.0}

const line0 = Line {
	a = pointZero
	b = pointOne
}

const line1 = Line {
	a = {x = 10, y = 20}
	b = {x = 30, y = 40}
}

const line2 = Line {
	a = pointZero
	b = pointOne
}

const line3 = Line {
	a = {x = 10, y = 20}
	b = {x = 30, y = 40}
}

const lines = [line0, line1, line2, line3]


type WrappedArray record {
	//array: [10]Int32
	x: Int32
}

const wa = WrappedArray {}


// Pythagorean theorem
func distance(a: Point, b: Point) -> Float {
	let dx = minmax.(a.x, b.x) - minmax.(a.x, b.x)
	let dy = minmax.(a.y, b.y) - minmax.(a.y, b.y)
	let dx2 = math.(dx, 2)
	let dy2 = math.(dy, 2)
	return math.(dx2 + dy2)
}


func lineLength(line: Line) -> Float {
	return distance(line.a, line.b)
}


public func main() -> Int {
	let lines_0_len = lineLength(lines[0])
	let lines_1_len = lineLength(lines[1])
	let lines_2_len = lineLength(lines[2])
	let lines_3_len = lineLength(lines[3])

	stdio.("lines_0_len = %f\n", lines_0_len)
	stdio.("lines_1_len = %f\n", lines_1_len)

	//	let y = wa.x

	//	var i = 0
	//	while i < 10 {
	//		let x = wa.array[i]
	//		printf("x[%d]=%d\n", i, x)
	//		++i
	//	}

	return 0
}

