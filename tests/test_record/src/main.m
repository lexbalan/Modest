// tests/test_record/src/main.m

pragma c_include "stdlib.h"

include "libc/ctypes64"
include "libc/stdio"


type MyInt = Int32
type Point = {
	@alias("c", "xx")
	x: Word64
	@alias("c", "yy")
	y: Word64
}

var p0: Point = {
	x = 1
 	y = 2
}

var points: []Point = [
	{x=00, y=10}
	{x=10, y=20}
	{x=30, y=40}
]


public func main () -> Int {
	let p0 = Point {x=10, y=10}
	let p1 = new Point {x=10, y=10}
	return 0
}

