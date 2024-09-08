// test/pre0/src/main.cm

include "console"
import "lib"


type Point record {
	x: Int32
	y: Int32
}


func main() -> lib.Int {
	let a = 10
	let b = 20
	let s = lib.mid(a, b)

	//printf("s = %d\n", s)

	// access to private value
	//let x = lib.div(a, b)

	var p = Point {x=10, y=20}
	lib.printPoint(p)

	return 0
}


