// tests/lang/type/unit/src/main.m

include "libc/ctypes64"
include "libc/stdlib"
include "libc/stdio"


const unit = {}


func unitFunc () -> {} {
	//var xunit = {}  // cannot create var with Unit type
	let unit = {}
	return unit
}


public func main () -> Int32 {
	printf("test Unit\n")

	var rc: Bool
	var success = true

	printf("test ")
	if not success {
		printf("failed\n")
    	return exitFailure
	}

    printf("passed\n")
    return exitSuccess
}


