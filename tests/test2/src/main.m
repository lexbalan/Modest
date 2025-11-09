include "libc/stdio"
include "libc/stdlib"
include "libc/string"


type Point = record {
	x: Int32 = 1
	y: Int32 = 2
}


type MyInt32 = @distinct Int32
type MyInt322 = @distinct MyInt32


func fx (i: MyInt322) -> Unit {
	//
}


public func main () -> Int32 {
	printf("test2\n")

	var p = Point {x=0}

	printf("p.x = %d\n", p.x)
	printf("p.y = %d\n", p.y)


	fx(MyInt322 5)

	return 0
}


