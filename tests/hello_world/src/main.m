// tests/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"

type Point = {x:Int64, y:Int64}

func foo (a: Int32, b: Int64) -> {} {
	return {}
}


const c = 15

//var a: Int32 = 5
var k: [3]Int32 = [1, 2, 3]

public func main () -> Int {

	let xc1: Char8 = "A"
	let xc2: Char16 = "A"
	let xc3: Char32 = "A"

	let xcs1: []Char8 = "A"
	let xcs2: []Char16 = "A"
	let xcs3: []Char32 = "A"

	let xs1: *Str8 = "A"
	let xs2: *Str16 = "A"
	let xs3: *Str32 = "A"


	var c1: Char8 = "B"
	var c2: Char16 = "B"
	var c3: Char32 = "B"

	var cs1: []Char8 = "B"
	var cs2: []Char16 = "B"
	var cs3: []Char32 = "B"

	var s1: *Str8 = "B"
	var s2: *Str16 = "B"
	var s3: *Str32 = "B"

	var arr = [3]Int32 [1, 2, 3]


	printf("Hello World!\n")

	var a: Int32
	var b: Int64
	a + 2
	a - 2
	a * 2
	a / 2
	a % 2
	foo(1, 2)
	foo(a + 1, b - c)
	1 + 2 - 3 * 4

	arr[1]
	//var p0 = Point {}
	if a < 1 and b > 12 or c <= 5 and not (1 < 0) {
		var u: Word32
		var v: Word32
		u or v and u xor not v
		u << 10; v >> 20;
		let pa = &a
		*pa
		(Int64 a + b)
		+a
		-a
		++a
		--a
	}

	true or false

	let pi = 3.1415

	var f: Float32
	f = pi

	return 0
}


