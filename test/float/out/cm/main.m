
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"
@c_include "stdlib.h"
include "libc/stdlib"
@c_include "math.h"
include "libc/math"


type Point2D record {
	x: Int
	y: Int
}
const mathPi = 3.141592653589793238462643383279502884
func squareOfCircle(radius: Float64) -> Float64 {
	return pow(radius, 2) * mathPi
}
func slope(a: Point2D, b: Point2D) -> Float32 {
	let dx = abs(a.x - b.x)
	let dy = abs(a.y - b.y)
	printf("dx = %d\n", dx)
	printf("dy = %d\n", dy)
	return Float32 dy / Float32 dx
}
public func main() -> Int {
	printf("float test\n")

	let r = 10
	let s = squareOfCircle(r)
	printf("s = %f\n", s)


	let k = 1.0 / 8
	printf("k = %f\n", k)

	printf("sizeof(Float32) = %lu\n", sizeof(Float32))
	printf("sizeof(Float64) = %lu\n", sizeof(Float64))

	// printf %f ожидает получить double а не float!
	let sl = slope({x = 10, y = 20}, {x = 30, y = 50})
	printf("slope = %f\n", Float64 sl)

	return 0
}

