private import "builtin"
include "ctypes64"
include "stdlib"
include "stdio"



const unit = {}


@used
func unitFunc () -> {} {
	let unit = {}
	return unit
}


public func main () -> Int32 {
	printf("test Unit\n")

	var rc: Bool
	var success: Bool = true

	printf("test ")
	if not success {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}

