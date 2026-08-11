// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: let forms
// EXPECT-OUT: passed: let generic
// EXPECT-OUT: passed: let reference
// EXPECT-OUT: passed: let
//
// Covers the `let` statement: an immutable binding to any runtime value.
// Without a type annotation it keeps the initializer's type — including
// the compile-time generic types of literals, which adapt at each use.

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


func mid (a: Int32, b: Int32) -> Int32 {
	let sum = a + b        // runtime value, type Int32
	let half: Int32 = sum / 2
	return half
}


func testForms () -> Bool {
	// Type taken from the initializer.
	let n = mid(10, 20)
	if n != 15 {
		printf("mid(10, 20) = %d, expected 15\n", n)
		return false
	}

	// Type stated explicitly.
	let limit: Int32 = 100
	if limit != 100 {
		printf("limit = %d, expected 100\n", limit)
		return false
	}

	// The initializer may be any runtime expression, including a call.
	var base: Int32 = 7
	let derived = base * mid(2, 4)
	if derived != 21 {
		printf("derived = %d, expected 21\n", derived)
		return false
	}

	printf("passed: let forms\n")
	return true
}


func testGeneric () -> Bool {
	// Without an annotation this stays a compile-time Integer, so it can
	// serve as Int32 in one place and Float64 in another.
	let count = 42

	var asInt: Int32 = count
	var asFloat: Float64 = count

	if asInt != 42 {
		printf("asInt = %d, expected 42\n", asInt)
		return false
	}
	if asFloat != 42.0 {
		printf("asFloat = %f, expected 42.0\n", asFloat)
		return false
	}

	let ratio = 0.5
	var half: Float32 = ratio
	if half != 0.5 {
		printf("half = %f, expected 0.5\n", Float64 half)
		return false
	}

	printf("passed: let generic\n")
	return true
}


func testReference () -> Bool {
	// The binding is immutable, but what it points at need not be.
	var n: Int32 = 1
	let p = &n

	*p = 50
	if n != 50 {
		printf("n = %d, expected 50\n", n)
		return false
	}

	let msg = *Str8 "let binds a string too\n"
	printf(msg)

	printf("passed: let reference\n")
	return true
}


func main () -> Int {
	var result = true
	result = testForms() and result
	result = testGeneric() and result
	result = testReference() and result

	if not result {
		printf("failed: let\n")
		return exitFailure
	}

	printf("passed: let\n")
	return exitSuccess
}
