
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"



public type Point record {
	x: Int32
	y: Int32
}


public const cq = "Hi!"


public var v0: Int32


//@attribute("value:nodecorate")
public func f0() -> Unit {

}

var i32: Int32
var u32: Nat32

public func main() -> Int32 {
	var p: Point
	stdio.printf("test %s\n", *Str8 cq)
	stdio.printf("test %d\n", v0)
	f0()

	let x = Int8 -1

	i32 = Int32 x
	u32 = Nat32 x

	if i32 == Int32 -1 {
		stdio.printf("Int8 -> Int32 test passed.\n")
	} else {
		stdio.printf("Int8 -> Int32 test failed.\n")
	}

	if u32 == Nat32 0xFF {
		stdio.printf("Int8 -> Nat32 test passed.\n")
	} else {
		stdio.printf("Int8 -> Nat32 test failed.\n")
	}

	stdio.printf("i32 = 0x%08x (%d)\n", i32, i32)
	stdio.printf("u32 = 0x%08x (%d)\n", u32, u32)

	return 0
}

