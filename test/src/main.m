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
public func f0() -> Unit {

}

var i32: Int32
var u32: Nat32


var prev_p: [10]Word8
func xxx(p: *[]Word8) -> Unit {
	let xp = *[10]Word8 p
	if prev_p != *xp {
		prev_p = *xp
	}
}



func mzero(p: Ptr, size: Nat32) {
	let px = unsafe *[size]Word8 p
	*px = []
}

func mcopy(dst: Ptr, src: Ptr, size: Nat32) {
	let d = unsafe *[size]Word8 dst
	let s = unsafe *[size]Word8 src
	*d = *s
}

func mcmp(a: Ptr, b: Ptr, size: Nat32) -> Bool {
	let ax = unsafe *[size]Word8 a
	let bx = unsafe *[size]Word8 b
	return *ax == *bx
}

@nodecorate
public func sbuf(p: Ptr, size: Nat32) {
	let px = unsafe *[size]Word8 p
	var buf = *px
	var i = Nat32 0
	while i < size {
		let x = buf[i]
		++i
	}
}


var xx: *@const[]*@volatile[10]Int
var yy: @volatile[10]Int


@extern("C")
public func ma() -> Int32


//type State enum {
//	#stateInit
//	#stateOff
//	#stateStartup
//	#stateRun
//	#stateShutdown
//}


func ab_ret(a: Int32, b: Int32) -> record {a: Int32, b: Int32} {
	return {a=a, b=b}
}

func ab_test() {
	let x = ab_ret(9, 11)
	printf("x.a = %i\n", x.a)
	printf("x.a = %i\n", x.b)
}

const ca = 4
var va = ca

const p0 = {x=1, y=2}
var p = p0

const ini = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

public func main() -> Int32 {
	ab_test()

	var p: Point
	printf("test %s\n", *Str8 cq)
	printf("test %d\n", v0)
	f0()

	printf("p0.x = %d\n", p0.x)

	var x1 = 5
	var x2 = 15

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
	var we: Word8 = Word8 Nat8 yy

	let pa2 = unsafe *[10]Int &a2

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

	if (Word32 Int8 -1 == 0xff) and (w32 == 0xff) {
		printf("Int8 -1 -> Word32 (0xff) test passed\n")
	} else {
		printf("Int8 -1 -> Word32 test failed\n")
	}

	//printf("i32 = 0x%08x (%d)\n", i32, i32)
	//printf("u32 = 0x%08x (%d)\n", u32, u32)

	return 0
}


