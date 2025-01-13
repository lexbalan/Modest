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

public func main() -> Int32 {
	var pa: *[][]Int32
	pa = &a
	p(&a)

	return 0
}


