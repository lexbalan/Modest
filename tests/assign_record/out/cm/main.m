
@c_include "stdio.h"


type Point record {
	x: Int32
	y: Int32
}

var globalPoint0: Point = {x = 10, y = 20}
var globalPoint1: Point = {}


public func main() -> Int {
	stdio.("test assign_array\n")

	globalPoint1 = globalPoint0

	stdio.("globalPoint1.x = %d\n", globalPoint1.x)
	stdio.("globalPoint1.x = %d\n", globalPoint1.y)

	if globalPoint0 == globalPoint1 {
		stdio.("globalPoint test passed\n")
	} else {
		stdio.("globalPoint test failed\n")
	}

	// local

	var localPoint0: Point = {x = 10, y = 20}
	var localPoint1: Point = {}

	localPoint1 = localPoint0

	stdio.("localPoint1.x = %d\n", localPoint1.x)
	stdio.("localPoint1.x = %d\n", localPoint1.y)

	if localPoint0 == localPoint1 {
		stdio.("localPoint test passed\n")
	} else {
		stdio.("localPoint test failed\n")
	}

	return 0
}

