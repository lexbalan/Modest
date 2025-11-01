// tests/10.const/src/main.m

include "libc/ctypes64"
include "libc/stdio"
include "libc/math"

pragma c_include "./minmax.h"

import "misc/minmax"


const carr = [0, 10, 15] + [20, 25, 30]


type Point = record {
	x: Float64
	y: Float64
}

type Line = record {
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
	a={x=10, y=20}
	b={x=30, y=40}
}

const line2 = Line {
	a = pointZero
	b = pointOne
}

const line3 = Line {
	a={x=10, y=20}
	b={x=30, y=40}
}

const lines = [line0, line1, line2, line3]


type WrappedArray = record {
	//array: [10]Int32
	x: Int32
}

const wa = WrappedArray {}


// Pythagorean theorem
func distance (a: Point, b: Point) -> Float {
	let dx = minmax.max_float64(a.x, b.x) - minmax.min_float64(a.x, b.x)
	let dy = minmax.max_float64(a.y, b.y) - minmax.min_float64(a.y, b.y)
	let dx2 = pow(dx, 2)
	let dy2 = pow(dy, 2)
	return sqrt(dx2 + dy2)
}


func lineLength (line: Line) -> Float {
	return distance(line.a, line.b)
}


public func main () -> Int {
	let lines_0_len = lineLength(lines[0])
	let lines_1_len = lineLength(lines[1])
	let lines_2_len = lineLength(lines[2])
	let lines_3_len = lineLength(lines[3])

	printf("lines_0_len = %f\n", lines_0_len)
	printf("lines_1_len = %f\n", lines_1_len)
	printf("lines_2_len = %f\n", lines_2_len)
	printf("lines_3_len = %f\n", lines_3_len)

//	let y = wa.x

//	var i: Nat32 = 0
//	while i < 10 {
//		let x = wa.array[i]
//		printf("x[%d]=%d\n", i, x)
//		++i
//	}

	return 0
}


