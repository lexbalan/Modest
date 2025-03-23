// tests/pre0/src/main.m

include "console"
import "lib"


type Point2 record {
	x: Int32
	y: Int32
}


//var p: lib.XXX

@nodecorate
public public func main() -> lib.Int {
	init()

	let a = 10
	let b = 20
	let s = lib.mid(a, b)

	printf("s = %d\n", s)

	// access to private value
	//let x = lib.div(a, b)

	var p = Point2 {x=10, y=20}
	lib.printPoint(p)

	return 0
}


func init() {
	printf("init!\n")
}


