// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: side effect ran
// EXPECT-OUT: passed: discarded result
// EXPECT-OUT: passed: explicit discard
// EXPECT-OUT: passed: eval
//
// Covers the value evaluation statement: an expression written on its own
// for its side effects, with the result dropped. `Unit x` is the explicit
// way to discard a value and silence the unused-value warning.

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


var calls: Int32


// Returns a value that callers are free to ignore.
func bump (by: Int32) -> Int32 {
	calls = calls + by
	return calls
}


func testDiscardedResult () -> Bool {
	calls = 0

	// Called as a statement: the returned Int32 goes nowhere, but the
	// side effect still happens.
	bump(2)
	bump(3)

	if calls != 5 {
		printf("calls = %d, expected 5\n", calls)
		return false
	}

	// The same call used as a value, for contrast.
	let n = bump(1)
	if n != 6 {
		printf("bump(1) = %d, expected 6\n", n)
		return false
	}

	printf("side effect ran\n")
	printf("passed: discarded result\n")
	return true
}


// A parameter this function has no use for.
func handler (payload: Ptr) -> Unit {
	Unit payload        // explicit discard
}


func testExplicitDiscard () -> Bool {
	calls = 0

	handler(nil)

	var n: Int32 = 1
	handler(&n)

	// `Unit value` discards any value, including a call's result.
	Unit bump(4)

	if calls != 4 {
		printf("calls = %d, expected 4\n", calls)
		return false
	}

	printf("passed: explicit discard\n")
	return true
}


func main () -> Int {
	var result = true
	result = testDiscardedResult() and result
	result = testExplicitDiscard() and result

	if not result {
		printf("failed: eval\n")
		return exitFailure
	}

	printf("passed: eval\n")
	return exitSuccess
}
