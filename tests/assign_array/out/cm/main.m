
@c_include "stdio.h"


var globalArray0: [<str_value>]Int32 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
var globalArray1: [<str_value>]Int32 = []


public func main() -> Int {
	stdio.("test assign_array\n")

	globalArray1 = globalArray0

	var i: Int32

	i = 0
	while i < 10 {
		let v = globalArray1[i]
		stdio.("globalArray1[%d] = %d\n", i, v)
		i = i + 1
	}

	if globalArray0 == globalArray1 {
		stdio.("globalArray test passed\n")
	} else {
		stdio.("globalArray test failed\n")
	}


	// local

	var localArray0: [<str_value>]Int32 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	var localArray1: [<str_value>]Int32 = []


	localArray1 = localArray0

	i = 0
	while i < 10 {
		let v = localArray1[i]
		stdio.("localArray1[%d] = %d\n", i, v)
		i = i + 1
	}

	if localArray0 == localArray1 {
		stdio.("localArray test passed\n")
	} else {
		stdio.("localArray test failed\n")
	}

	return 0
}

