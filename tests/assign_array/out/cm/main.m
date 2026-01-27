include "ctypes64"
include "stdio"



var globalArray0: [10]Int32 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
var globalArray1: [10]Int32 = []


public func main () -> Int {
	printf("test assign_array\n")

	globalArray1 = globalArray0

	var i: Int32

	i = 0
	while i < 10 {
		let v: Int32 = globalArray1[i]
		printf("globalArray1[%d] = %d\n", Int32 i, Int32 v)
		i = i + 1
	}

	if globalArray0 == globalArray1 {
		printf("globalArray test passed\n")
	} else {
		printf("globalArray test failed\n")
	}


	// local

	var localArray0: [10]Int32 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	var localArray1: [10]Int32 = []


	localArray1 = localArray0

	i = 0
	while i < 10 {
		let v: Int32 = localArray1[i]
		printf("localArray1[%d] = %d\n", Int32 i, Int32 v)
		i = i + 1
	}

	if localArray0 == localArray1 {
		printf("localArray test passed\n")
	} else {
		printf("localArray test failed\n")
	}

	return 0
}

