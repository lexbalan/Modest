// tests/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"


func foo(a: Int32, b: Int64) -> {} {
	return {}
}


const c = 15

public func main () -> Int {
	//printf("Hello World!\n")
	var a: Int32
	var b: Int64
	foo(1, 2)
	foo(a + 1, b - c)
	1 + 2 - 3 * 4
	var arr = [3]Int32 [1, 2, 3]
	arr[1]
	if a < 1 and b > 12 or c <= 5 and not 1 < 0 {
		var u: Word32
		var v: Word32
		u or v and u xor v
		u << 10; v >> 20;
		let pa = &a
		*pa
		(Int64 a + b)
		+a
		-a
	}
	return 0
}

