
include "libc/stdio"
include "libc/stdlib"
include "libc/string"

import "lib"
import "fixed32"


func testFixed () -> Unit {
	let fp0 = fixed32.create(1, 2, 4) // 1+2/4
	printf("fp0 = 0x%08x ", fp0)
	fixed32.print(fp0)
	printf("\n")

	let fp1 = fixed32.create(1, 1, 2) // 1+1/2
	printf("fp1 = 0x%08x ", fp1)
	fixed32.print(fp1)
	printf("\n")

	let fp2 = fixed32.create(1, 1, 3) // 1+1/3
	printf("fp2 = 0x%08x ", fp2)
	fixed32.print(fp2)
	printf("\n")

	let fp3 = fixed32.create(1, 2, 128) // 1+2/128 = 1+1/64 = 1+1024/65536
	printf("fp3 = 0x%08x ", fp3)
	fixed32.print(fp3)
	printf("\n")

	let fp4 = fixed32.add(fp0, fp1)
	printf("fp4 = 0x%08x ", fp4)
	fixed32.print(fp4)
	printf("\n")

	let fp5 = fixed32.mul(fp0, fp1)
	printf("fp5 = 0x%08x ", fp5)
	fixed32.print(fp5)
	printf("\n")

	let one = fixed32.create(1, 0, 1) // 1+0/1
	let two = fixed32.create(2, 0, 1) // 2+0/1
	let dv = fixed32.div(one, two)
	printf("dv = 0x%08x ", dv)
	fixed32.print(dv)
	printf("\n")

	let pi = fixed32.create(3, 1415, 10000) // 3+14/100
	printf("pi = 0x%08x ", pi)
	fixed32.print(pi)
	printf("\n")

	let tr = fixed32.trunc(pi)
	printf("trunc(pi) = 0x%08x ", tr)
	fixed32.print(tr)
	printf("\n")

	let fr = fixed32.fract(pi)
	printf("fract(pi) = 0x%08x ", fr)
	fixed32.print(fr)
	printf("\n")

	// ok!
//	let dv2 = fixed32.div(pi, two)
//	printf("dv2 = 0x%08x ", dv2)
//	fixed32.print(dv2)
//	printf("\n")

	let zero = fixed32.fromInt16(0)

	// -1+0/1 = ok
	let mone = fixed32.sub(zero, one)
	printf("mone = 0x%08x ", mone)
	fixed32.print(mone)
	printf("\n")

	var t2 = two

	let oone = fixed32.add(t2, mone)
	printf("oone = 0x%08x ", oone)
	fixed32.print(oone)
	printf("\n")

	let semi = fixed32.sub(zero, fixed32.fromInt16(180))
	printf("semi = 0x%08x ", semi)
	fixed32.print(semi)
	printf("\n")

	//let xx = fixed32.fromInt16(380)
	let dv2 = fixed32.div(semi, two)
	printf("dv2 = 0x%08x ", dv2)
	fixed32.print(dv2)
	printf("\n")
}


type NewType = @distinct Int32
const newZero = NewType 0
const newOne = NewType 1
const newTwo = NewType 2
const newThree = NewType 3


func distinctCheck () -> Unit {
	var a, b: NewType
	let x = a + b + newZero + NewType 0
	var y: Int16 = unsafe Int16 x
	var xx: Int32 = unsafe Int32 x
	//
}

func add (a: Int32, b: Int32) -> Int32 {
	return a + b
}

//const yx = add(2, 2)

public type Point = @packed record {
	x: Int32  // hi!
	y: Int32  // lo?
}

public const cq = "Hi!"

var v0: Int32

public func f0() -> Unit {

}

@nonstatic
var i32: Int32
@alignment(4)
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
	let px = unsafe *[size]Word8 p
	*px = []
}


func mcopy (dst: Ptr, src: Ptr, size: Nat32) -> Unit {
	let pd = unsafe *[size]Word8 dst
	let ps = unsafe *[size]Word8 src
	*pd = *ps
}


func mcmp (a: Ptr, b: Ptr, size: Nat32) -> Bool {
	let pa = unsafe *[size]Word8 a
	let pb = unsafe *[size]Word8 b
	return *pa == *pb
}


public func sbuf (p: Ptr, size: Nat32) -> Unit {
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
func ma () -> Int32


//func ab_ret (a: Int32, b: Int32) -> record {a: Int32, b: Int32} {
//	return {a=a, b=b}
//}
//
//func ab_test () -> Unit {
//	let x = ab_ret(9, 11)
//	printf("x.a = %i\n", x.a)
//	printf("x.a = %i\n", x.b)
//}

const ca = 4
var va = ca

const p0 = {x=1, y=2}
var p = p0

const ini = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]


@extern("C")
var yyy: @volatile [32]Int32



func divtest () -> Unit {
    var a: Int32 = 7
	var b: Int32 = -3
    printf("%d / %d = %d\n", a, b, a / b)
    printf("%d %% %d = %d\n", a, b, a % b)
}



func argtest (a: Int32, b: Int32=0) -> Int32 {
	return a + b
}


public func main () -> Int32 {
	//ab_test()

	argtest(1)
	argtest(1, 2)
	argtest(1, b=3)

	testFixed()

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


