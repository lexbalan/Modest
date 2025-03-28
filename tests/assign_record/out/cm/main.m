include "ctypes64"
include "stdio"



type Point record {
	x: Int32
	y: Int32
}

var globalPoint0: Point = {x = 10, y = 20}
var globalPoint1: Point = {}


public func main() -> Int {
	stdio.printf("test assign_array\n")

	globalPoint1 = globalPoint0

	stdio.printf("globalPoint1.x = %d\n", globalPoint1.x)
	stdio.printf("globalPoint1.x = %d\n", globalPoint1.y)

	if globalPoint0 == globalPoint1 {
		stdio.printf("globalPoint test passed\n")
	} else {
		stdio.printf("globalPoint test failed\n")
	}

	// local

	var localPoint0: Point = {x = 10, y = 20}
	var localPoint1: Point = {}

	localPoint1 = localPoint0

	stdio.printf("localPoint1.x = %d\n", localPoint1.x)
	stdio.printf("localPoint1.x = %d\n", localPoint1.y)

	if localPoint0 == localPoint1 {
		stdio.printf("localPoint test passed\n")
	} else {
		stdio.printf("localPoint test failed\n")
	}

	return 0
}

