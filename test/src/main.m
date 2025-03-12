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

//	let x = Int8 -1
//
//	i32 = Int32 x
//	u32 = Nat32 x

	// не проверяет дубликаты имен!
	var x: Int32 = 1
	//var y: Int32 = 0x1  // error!
	var z: Word32 = 1
	var w: Word32 = 0x1

	let i8 = Int8 -1
	let n32 = Nat32 i8
	let i32 = Int32 i8
	let w32 = Word32 i8

	if (Int32 Int8 -1 == -1) and (i32 == -1) {
		printf("Int8 -1 -> Int32 (-1) test passed\n")
	} else {
		printf("Int8 -1 -> Int32 test failed\n")
	}

	if (Nat32 Int8 -1 == 1) and (n32 == 1) {
		printf("Int8 -1 -> Nat32 (1) test passed\n")
	} else {
		printf("Int8 -1 -> Nat32 test failed\n")
	}

	if (Word32 Int8 -1 == 0xff) and (w32 == 0xff) {
		printf("Int8 -1 -> Word32 (0xff) test passed\n")
	} else {
		printf("Int8 -1 -> Word32 test failed\n")
	}

	//printf("i32 = 0x%08x (%d)\n", i32, i32)
	//printf("u32 = 0x%08x (%d)\n", u32, u32)

	return 0
}


