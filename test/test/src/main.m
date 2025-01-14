include "libc/stdio"
include "libc/stdlib"
include "libc/string"

//@property("type.generic", true)

var a: [2][3]Int32 = [
	[1, 2, 3]
	[4, 5, 6]
]


func p(pa: *[][]Int32) {

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


