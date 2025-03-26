
@c_include "stdio.h"

const arr = [Int32 1, Int32 2]

var arr0: [<str_value>]Int32 = arr
var arr1: [<str_value>]Int32 = arr
var str: *[]Char8 = "Hello!"// -> *[]Char8


public func main() -> Int {
	var x: Int32 = 127
	var y: Int32 = x + 1

	stdio.("y = %i\n", y)

	if y == 128 {
		stdio.("test passed\n")
	} else {
		stdio.("test failed\n")
	}

	return 0
}

