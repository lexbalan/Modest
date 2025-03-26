
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "math.h"


const mathPi = 3.141592653589793238462643383279502884


func squareOfCircle(radius: Float64) -> Float64 {
	return math.(radius, 2) * mathPi
}


type Point2D record {
	x: Int
	y: Int
}


func slope(a: Point2D, b: Point2D) -> Float32 {
	let dx = stdlib.(a.x - b.x)
	let dy = stdlib.(a.y - b.y)
	stdio.("dx = %d\n", dx)
	stdio.("dy = %d\n", dy)
	return Float32 dy / Float32 dx
}


public func main() -> Int {
	stdio.("float test\n")

	stdio.("2 = %d\n", Int32 2)
	stdio.("2/3 = %f\n", Float64 (2.0 / 3))

	let r = 10
	let s = squareOfCircle(r)
	stdio.("s = %f\n", s)

	let k = 1.0 / 8
	stdio.("k = %f\n", Float64 k)

	stdio.("sizeof(Float32) = %lu\n", sizeof(Float32))
	stdio.("sizeof(Float64) = %lu\n", sizeof(Float64))

	// printf %f ожидает получить double а не float!
	let sl = slope({x = 10, y = 20}, {x = 30, y = 50})
	stdio.("slope = %f\n", Float64 sl)

	return 0
}

