include "stdio"
include "stdlib"
include "string"



type Point = record {
	x: Int32
	y: Int32
}


var points: [3]Point = [
	Point {x = 0, y = 0}
	Point {x = 1, y = 1}
	Point {x = 2, y = 2}
]

public func main () -> Int32 {
	printf("test2\n")

	return 0
}

