include "stdio"
include "stdlib"
include "string"



func add (a: Int32, b: Int32) -> Int32 {
	return a + b
}


public type Point record {
	x: Int32  // hi!
	y: Int32  // lo?
}

public const cq = "Hi!"

public var v0: Int32

public func f0 () -> Unit {
}


var i32: Int32

var u32: Nat32


var a32: Word32


var prev_p: [10]Word8
func xxx (p: *[]Word8) -> Unit {
	let xp = *[10]Word8 p
	if prev_p != *xp {
		prev_p = *xp
	}
}



func mzero (p: Ptr, size: Nat32) -> Unit {
	let px: *[size]Word8 = *[size]Word8 p
	*px = []
}


func mcopy (dst: Ptr, src: Ptr, size: Nat32) -> Unit {
	let pd: *[size]Word8 = *[size]Word8 dst
	let ps: *[size]Word8 = *[size]Word8 src
	*pd = *ps
}


func mcmp (a: Ptr, b: Ptr, size: Nat32) -> Bool {
	let pa: *[size]Word8 = *[size]Word8 a
	let pb: *[size]Word8 = *[size]Word8 b
	return *pa == *pb
}


public func sbuf (p: Ptr, size: Nat32) -> Unit {
	let px: *[size]Word8 = *[size]Word8 p
	var buf: [size]Word8 = *px
	var i = Nat32 0
	while i < size {
		let x: Word8 = buf[i]
		i = i + 1
	}
}


var xx: *[]*[10]Int
var yy: [10]Int





const ca = 4
var va: Int32 = ca

const p0 = {x = 1, y = 2}
var p = p0

const ini = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]



var yyy: [32]Int32



func divtest () -> Unit {
	var a: Int32 = 7
	var b: Int32 = -3
	printf("%d / %d = %d\n", a, b, a / b)
	printf("%d %% %d = %d\n", a, b, a % b)
}

public func main () -> Int32 {
	//ab_test()

	divtest()

	var p: Point
	printf("test %s\n", *Str8 cq)
	printf("test %d\n", v0)
	//f0()

	printf("p0.x = %d\n", p0.x)

	var x1 = Int32 5
	var x2 = Int32 15

	var w0: [10]Word8 = ini
	var a0: [10]Int32 = ini
	//
	var a1: [5]Int32 = a0[2:7]
	//
	var a2: [20]Int32
	a2[5:15] = a0
	//
	var a3: [20]Int32
	a3[x1:x2] = a0
	//
	a3[3:12] = a2[4:13]
	//
	a0 = a3[3:13]
	//
	a3[3:13] = []

	var a4: [10]Int32 = []

	xxx(&w0)

	var yy = Word8 1
	var we = Word8 Nat8 yy

	let pa2: *[10]Int = *[10]Int &a2

	if *pa2 == a0 {
		printf("eq!\n")
	} else {
		printf("eq!\n")
	}

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

	if (Word32 Int8 -1 == 0xFF) and (w32 == 0xFF) {
		printf("Int8 -1 -> Word32 (0xff) test passed\n")
	} else {
		printf("Int8 -1 -> Word32 test failed\n")
	}

	//printf("i32 = 0x%08x (%d)\n", i32, i32)
	//printf("u32 = 0x%08x (%d)\n", u32, u32)

	return 0
}

