include "libc/stdio"
include "libc/stdlib"
include "libc/string"

//@property("type.generic", true)

var a: [2][3]Int32 = [
	[1, 2, 3]
	[4, 5, 6]
]


func p(pa: *[][]Int32) {
	var a = 2
	var b = 3
	let pg = *[a][b]Int32 pa
	printf("pa[0][0] = %i\n", pa[1][0])
}


func foo(x: Int32, y: Int32 = 50) {
	printf("foo(%d, %d)\n", x, y)
}


//$pragma insert "// text insertion"

public func main() -> Int32 {
	var pa: *[][]Int32
	pa = &a
	p(&a)

	foo(1, 2)

	return 0
}


