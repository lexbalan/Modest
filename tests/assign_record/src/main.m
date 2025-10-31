// tests/assign_record/src/main.m

include "libc/ctypes64"
include "libc/stdio"


type Point = record {
	x: Int32
	y: Int32
}

var globalPoint0: Point = {x=10, y=20}
var globalPoint1: Point = {}


public func main () -> Int {
	printf("test assign_array\n")

	globalPoint1 = globalPoint0

	printf("globalPoint1.x = %d\n", globalPoint1.x)
	printf("globalPoint1.x = %d\n", globalPoint1.y)

	if globalPoint0 == globalPoint1 {
		printf("globalPoint test passed\n")
	} else {
		printf("globalPoint test failed\n")
	}

	// local

	var localPoint0: Point = {x=10, y=20}
	var localPoint1: Point = {}

	localPoint1 = localPoint0

	printf("localPoint1.x = %d\n", localPoint1.x)
	printf("localPoint1.x = %d\n", localPoint1.y)

	if localPoint0 == localPoint1 {
		printf("localPoint test passed\n")
	} else {
		printf("localPoint test failed\n")
	}

	return 0
}

