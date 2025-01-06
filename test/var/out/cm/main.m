
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"

const arr = [Int32 1, Int32 2]

var arr0: [2]Int32 = arr
var arr1: [2]Int32 = arr
var str: *[/*U*/]Char8 = "Hello!"


public func main() -> Int {
	var x: Int32 = 127
	var y: Int32 = x + 1

	printf("y = %i\n", y)

	if y == 128 {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}

	return 0
}

