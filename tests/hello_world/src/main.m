// tests/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"


func foo (a: Int32, b: Int64) -> {} {
	return {}
}


const c = 15

public func main () -> Int {
	printf("Hello World!\n")

	var c1: Char8 = 'A'
	var c2: Char16 = 'A'
	var c3: Char32 = 'A'

	var s1: *Str8 = "Hi!"
	var s2: *Str16 = "Hi!∆"
	var s3: *Str32 = "Hi!∆"

	var cs1: []Char8 = "Hi!"
	var cs2: []Char16 = "Hi!∆"
	var cs3: []Char32 = "Hi!∆"

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
	var arr = [3]Int32 [1, 2, 3]
	arr[1]
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

