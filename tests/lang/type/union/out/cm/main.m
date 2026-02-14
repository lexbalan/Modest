include "ctypes64"
include "stdlib"
include "stdio"



// Not implemented in LLVM (!)
type Union1 = @union {
	_nat: Nat64
	_float: Float64
}



@used
var u1: Union1


func max (a: Nat64, b: Nat64) -> Nat64 {
	if a > b {
		return a
	}
	return b
}


public func main () -> Int32 {
	printf("union test\n")

	var success: Bool = true

	if sizeof(Union1) != max(sizeof(Nat64), sizeof(Float64)) {
		success = false
	}

	if alignof(Union1) != max(alignof(Nat64), alignof(Float64)) {
		success = false
	}

	if sizeof(Union1) != sizeof u1 {
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

