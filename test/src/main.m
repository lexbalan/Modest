include "libc/stdio"
include "libc/stdlib"
include "libc/string"


@c_alias("POINT")
type Point record {
	x: Int32
	y: Int32
}

@c_alias("STR")
const cq = "Hi!"

@c_alias("vaw")
var v0: Int32

@c_alias("func")
func f0() -> Unit {

}

public func main() -> Int32 {
	var p: Point
	printf("test %s\n", *Str8 cq)
	printf("test %d\n", v0)
	f0()
	return 0
}

