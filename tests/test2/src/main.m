include "libc/stdio"
include "libc/stdlib"
include "libc/string"


type Point = record {
	x: Int32 = 1
	y: Int32 = 2
}


public func main() -> Int32 {
	printf("test2\n")

	var p = Point {x=0}

	printf("p.x = %d\n", p.x)
	printf("p.y = %d\n", p.y)

	return 0
}


