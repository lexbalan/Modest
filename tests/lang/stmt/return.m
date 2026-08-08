// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: return value
// EXPECT-OUT: passed: return construction
// EXPECT-OUT: passed: unit return
// EXPECT-OUT: passed: return
//
// Covers the `return` statement: returning a value, the implicit
// construction of that value to the declared return type, and the bare
// `return` of a Unit function (which may also be left out entirely).

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


func mid (a: Int32, b: Int32) -> Int32 {
	return (a + b) / 2
}


// Every path returns; the early one wins.
func abs32 (n: Int32) -> Int32 {
	if n < 0 {
		return -n
	}
	return n
}


func testValue () -> Bool {
	if mid(10, 20) != 15 {
		printf("mid(10, 20) = %d, expected 15\n", mid(10, 20))
		return false
	}

	if abs32(-7) != 7 {
		printf("abs32(-7) = %d, expected 7\n", abs32(-7))
		return false
	}

	if abs32(7) != 7 {
		printf("abs32(7) = %d, expected 7\n", abs32(7))
		return false
	}

	printf("passed: return value\n")
	return true
}


// The returned literal is a compile-time Integer, constructed to Nat8 here.
func smallConstant () -> Nat8 {
	return 200
}


// Widening is not implicit either: even Int32 -> Int64 is written out.
func widened () -> Int64 {
	var n: Int32 = 1000
	return Int64 n
}


func testConstruction () -> Bool {
	if smallConstant() != 200 {
		printf("smallConstant() = %d, expected 200\n", Int32 smallConstant())
		return false
	}

	if widened() != 1000 {
		printf("widened() returned the wrong value, expected 1000\n")
		return false
	}

	printf("passed: return construction\n")
	return true
}


var sideEffects: Int32


// Bare `return` as an early exit from a Unit function.
func record (enabled: Bool) -> Unit {
	if not enabled {
		return
	}
	sideEffects = sideEffects + 1
}


// A Unit function needs no `return` at the end at all.
func recordTwice () -> Unit {
	record(true)
	record(true)
}


func testUnit () -> Bool {
	sideEffects = 0

	record(false)
	if sideEffects != 0 {
		printf("sideEffects = %d, expected 0 after an early return\n", sideEffects)
		return false
	}

	record(true)
	if sideEffects != 1 {
		printf("sideEffects = %d, expected 1\n", sideEffects)
		return false
	}

	recordTwice()
	if sideEffects != 3 {
		printf("sideEffects = %d, expected 3\n", sideEffects)
		return false
	}

	printf("passed: unit return\n")
	return true
}


func main () -> Int {
	var result = true
	result = testValue() and result
	result = testConstruction() and result
	result = testUnit() and result

	if not result {
		printf("failed: return\n")
		return exitFailure
	}

	printf("passed: return\n")
	return exitSuccess
}
