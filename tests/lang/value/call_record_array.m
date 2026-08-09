// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: array field of a record argument
// EXPECTED-FAIL(llvm): BUGS.md#17 array field of a by-value record parameter
//
// Split out of call.m so that one backend-specific defect does not cost
// the whole call test its LLVM coverage. Fold it back into call.m once
// BUGS.md #17 is fixed.
//
// A record that arrives as a by-value parameter has no address, so the
// LLVM backend reaches its fields with `extractvalue` — and then indexes
// the resulting array value with `getelementptr`, which needs a pointer.
// The same record read from a global or a local works, because those do
// have an address.

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


type Boxed = {
	tag: Int32
	data: [3]Int32
}


var globalBox: Boxed


func fromParameter (b: Boxed) -> Int32 {
	return b.tag + b.data[0] + b.data[1] + b.data[2]
}


func fromGlobal () -> Int32 {
	return globalBox.tag + globalBox.data[0]
}


func fromLocal () -> Int32 {
	var local = Boxed {tag = 1, data = [10, 20, 30]}
	return local.tag + local.data[0]
}


func testArrayFieldOfRecord () -> Bool {
	// These two work on every backend.
	globalBox = Boxed {tag = 1, data = [10, 20, 30]}
	if fromGlobal() != 11 {
		printf("fromGlobal() = %d, expected 11\n", fromGlobal())
		return false
	}
	if fromLocal() != 11 {
		printf("fromLocal() = %d, expected 11\n", fromLocal())
		return false
	}

	// This is the one that fails on llvm.
	let b = Boxed {tag = 1, data = [10, 20, 30]}
	if fromParameter(b) != 61 {
		printf("fromParameter(b) = %d, expected 61\n", fromParameter(b))
		return false
	}

	printf("passed: array field of a record argument\n")
	return true
}


func main () -> Int {
	if not testArrayFieldOfRecord() {
		printf("failed: array field of a record argument\n")
		return exitFailure
	}
	return exitSuccess
}
