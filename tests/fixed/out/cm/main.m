include "ctypes64"
include "stdlib"
include "stdio"
include "limits"




const point0 = {x = 0, y = 0}
const point1 = {x = 1, y = 0}
const point12 = {x = 1, y = 1}


public func testRecordsEq () -> Bool {

	if point0 != point0 {
		printf("point0 != point0\n")
		return false
	}
	if point1 != point1 {
		printf("point1 != point1\n")
		return false
	}
	if point12 != point12 {
		printf("point0 != point0\n")
		return false
	}

	if point0 == point1 {
		printf("point0 == point1\n")
		return false
	}
	if point1 == point0 {
		printf("point1 == point0\n")
		return false
	}
	if point0 == point12 {
		printf("point0 == point12\n")
		return false
	}

	printf("passed: record eq test\n")
	return true
}



const arr123 = [1, 2, 3]
const arr321 = [3, 2, 1]

const carr123 = [3]Int32 [1, 2, 3]
const carr321 = [3]Int32 [3, 2, 1]

var varr123: [3]Int32 = [1, 2, 3]
var varr321: [3]Int32 = [3, 2, 1]

public func testArraysEq () -> Bool {

	if arr123 != arr123 {
		printf("arr123 != arr123\n")
		return false
	}

	if arr321 != arr321 {
		printf("arr321 != arr321\n")
		return false
	}

	if arr123 != carr123 {
		printf("arr123 != carr123\n")
		return false
	}

	if carr123 != arr123 {
		printf("carr123 != arr123\n")
		return false
	}

	if arr123 == arr321 {
		printf("arr123 == arr321\n")
		return false
	}

	if carr123 == carr321 {
		printf("carr123 == carr321\n")
		return false
	}

	if varr123 != varr123 {
		printf("varr123 != varr123\n")
		return false
	}

	if varr321 != varr321 {
		printf("varr321 != varr321\n")
		return false
	}

	if varr123 != arr123 {
		printf("varr123 != arr123\n")
		return false
	}

	if varr123 != carr123 {
		printf("varr123 != carr123\n")
		return false
	}

	if varr321 != arr321 {
		printf("varr321 != arr321\n")
		return false
	}

	if varr321 != carr321 {
		printf("varr321 != carr321\n")
		return false
	}


	printf("passed: array eq test\n")
	return true
}



public func main () -> Int32 {
	printf("test eq\n")

	var result: Bool
	var success: Bool = true

	result = testRecordsEq()
	success = success and result
	result = testArraysEq()
	success = success and result

	printf("test ")
	if not success {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}

