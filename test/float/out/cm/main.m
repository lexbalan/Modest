
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "math.h"


const mathPi = 3.141592653589793238462643383279502884


func squareOfCircle(radius: Float64) -> Float64 {
	return math.pow(radius, 2) * mathPi
}


type Point2D record {
	x: ctypes64.Int
	y: ctypes64.Int
}


func slope(a: Point2D, b: Point2D) -> Float32 {
	let dx = stdlib.abs(a.x - b.x)
	let dy = stdlib.abs(a.y - b.y)
	stdio.printf("dx = %d\n", dx)
	stdio.printf("dy = %d\n", dy)
	return Float32 dy / Float32 dx
}


public func main() -> ctypes64.Int {
	stdio.printf("float test\n")

	stdio.printf("2 = %d\n", Int32 2)
	stdio.printf("2/3 = %f\n", Float64 2.0 / 3)

	let r = 10
	let s = squareOfCircle(r)
	stdio.printf("s = %f\n", s)

	let k = 1.0 / 8
	stdio.printf("k = %f\n", Float64 k)

	stdio.printf("sizeof(Float32) = %lu\n", sizeof(Float32))
	stdio.printf("sizeof(Float64) = %lu\n", sizeof(Float64))

	// printf %f ожидает получить double а не float!
	let sl = slope({x = 10, y = 20}, {x = 30, y = 50})
	stdio.printf("slope = %f\n", Float64 sl)

	return 0
}

