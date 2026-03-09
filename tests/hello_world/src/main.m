// tests/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"


type MyInt = Int32
type Point = {
	x: Word64
	y: Word64
}

type OpenPoint = @public {
	x: Word64
	y: Word64
}

type ListHeader = @public {
	next: *ListHeader
	prev: *ListHeader
}

func foo (a: Int32, b: Int64) -> {} {
	return {}
}


const c = 15

//var a: Int32 = 5
var k: [3]Word32 = [1, 2, 3]

var p0: Point = {
	x = 1
 	y = 2
}

public func main () -> Int {
	// constants
	let c00 = 10

	let xc1: Char8 = "A"
	let xc2: Char16 = "A"
	let xc3: Char32 = "A"

	let xcs1: []Char8 = "A"
	let xcs2: []Char16 = "A"
	let xcs3: []Char32 = "A"

	let xs1: *Str8 = "A"
	let xs2: *Str16 = "A"
	let xs3: *Str32 = "A"

	// vars
	var v00 = Int32 10

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

	lengthof(arr)

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
	let kk = 1 + 2 - 3 * 4
	let pp = 3.1415

	{} a
	Nat32 a
	Nat64 b

	sizeof(a)
	sizeof(Nat32)

	arr[1]
	var p0 = Point {}
	p0.x
	p0.y
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


public func print (form: *Str8, ...) -> Unit {
	var va: __VA_List
	var va2: __VA_List
	__va_start(va, form)
	__va_copy(va2, va)
	//vfprint(c_STDOUT_FILENO, form, va)
	__va_end(va)
}

