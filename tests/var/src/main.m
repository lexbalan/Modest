// tests/var/src/main.m

include "libc/ctypes64"
include "libc/stdio"

const arr = [Int32 1, Int32 2]

var arr0 = arr
var arr1: []Int32 = arr
var str = "Hello!"   // -> *[]Char8


public func main () -> Int {
	var x: Int32 = 127
	var y = x + 1

	printf("y = %i\n", y)

	if y == 128 {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}

	return 0
}

