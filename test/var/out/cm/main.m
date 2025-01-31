
@c_include "stdio.h"

const arr = [Int32 1, Int32 2]

var arr0: [2]Int32 = arr
var arr1: [2]Int32 = arr
var str: *[]Char8 = "Hello!"// -> *[]Char8


public func main() -> ctypes64.Int {
	var x: Int32 = 127
	var y: Int32 = x + 1

	stdio.printf("y = %i\n", y)

	if y == 128 {
		stdio.printf("test passed\n")
	} else {
		stdio.printf("test failed\n")
	}

	return 0
}

