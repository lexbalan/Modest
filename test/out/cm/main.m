
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

	//	let x = Int8 -1
	//
	//	i32 = Int32 x
	//	u32 = Nat32 x

	if Int32 Int8 -1 == Int32 -1 {
		stdio.printf("Int8 -1 -> Int32 test passed\n")
	} else {
		stdio.printf("Int8 -1 -> Int32 test failed\n")
	}

	if Nat32 Int8 -1 == Nat32 1 {
		stdio.printf("Int8 -1 -> Nat32 test passed\n")
	} else {
		stdio.printf("Int8 -1 -> Nat32 test failed\n")
	}

	let c3 = Word32 Int8 -1
	if c3 == 0xFF {
		stdio.printf("Int8 -1 -> Word32 test passed\n")
	} else {
		stdio.printf("Int8 -1 -> Word32 test failed\n")
	}

	//printf("i32 = 0x%08x (%d)\n", i32, i32)
	//printf("u32 = 0x%08x (%d)\n", u32, u32)

	return 0
}

