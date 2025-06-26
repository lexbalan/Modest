// tests/float/src/main.m

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"
include "libc/math"


const mathPi = 3.141592653589793238462643383279502884


func squareOfCircle (radius: Float64) -> Float64 {
	return pow(radius, 2) * mathPi
}


type Point2D = record {
	x: Int
	y: Int
}


func slope (a: Point2D, b: Point2D) -> Float32 {
	let dx = abs(a.x - b.x)
	let dy = abs(a.y - b.y)
	printf("dx = %d\n", dx)
	printf("dy = %d\n", dy)
	return Float32 dy / Float32 dx
}


public func main () -> Int {
	printf("float test\n")

	printf("2 = %d\n", Int32 2)
	printf("2/3 = %f\n", Float64 (2.0 / 3))

	let r = 10
	let s = squareOfCircle(r)
	printf("s = %f\n", s)

	let k = 1.0 / 8
	printf("k = %f\n", Float64 k)

	printf("sizeof(Float32) = %zu\n", sizeof(Float32))
	printf("sizeof(Float64) = %zu\n", sizeof(Float64))

	// printf %f ожидает получить double а не float!
	let sl = slope({x=10, y=20}, {x=30, y=50})
	printf("slope = %f\n", Float64 sl)

	return 0
}

