// tests/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"


func foo(a: Int32, b: Int64) -> {} {
	return {}
}

public func main () -> Int {
	//printf("Hello World!\n")
	var a: Int32
	var b: Int64
	foo(1, 2)
	foo(a + 1, b - 1)
	1 + 2 - 3 * 4
	return 0
}

