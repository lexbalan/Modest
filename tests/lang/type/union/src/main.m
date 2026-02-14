// tests/union/src/main.m

include "libc/ctypes64"
include "libc/stdio"


// Not implemented in LLVM (!)
type Union1 = @union {
	_nat: Nat64
	_float: Float64
}


@used
var u1: Union1


public func main () -> Int32 {
	printf("union test\n")

	let success = true

	if sizeof(Union1) != max(sizeof(Union._nat), sizeof(Union._float)) {
		success = false
	}

	if alignof(Union1) != max(alignof(Union._nat), alignof(Union._float)) {
		success = false
	}

	if sizeof(Union1) != sizeof(u1) {
		success = false
	}

	if offsetof(Union1._nat) != 0 {
		success = false
	}

	if offsetof(Union1._float) != 0 {
		success = false
	}

	//printf("sizeof(Union1) = %lu\n", sizeof(Union1))
	//printf("sizeof(u1) = %lu\n", sizeof(u1))

	printf("test ")
	if not success {
		printf("failed\n")
    	return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}

