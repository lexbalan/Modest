include "libc/stdio"
include "libc/stdlib"
include "libc/string"


@nodecorate
public type Point record {
	x: Int32
	y: Int32
}

@nodecorate
public const cq = "Hi!"

@nodecorate
public var v0: Int32

@nodecorate
//@attribute("value:nodecorate")
public func f0() -> Unit {

}

var i32: Int32
var u32: Nat32

public func main() -> Int32 {
	var p: Point
	printf("test %s\n", *Str8 cq)
	printf("test %d\n", v0)
	f0()

	let x = Int8 -1

	i32 = Int32 x
	u32 = Nat32 x
	printf("i32 = 0x%08x (%d)\n", i32, i32)
	printf("u32 = 0x%08x (%d)\n", u32, u32)
	return 0
}

