// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: if chain
// EXPECT-OUT: passed: if without else
// EXPECT-OUT: passed: explicit conditions
// EXPECT-OUT: passed: if
//
// Covers the `if` statement: else-if chains, the optional final `else`,
// and the rule that a condition is Bool — numbers and pointers never
// convert implicitly, so the comparison is always written out.

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


func compare (a: Int32, b: Int32) -> Int32 {
	if a > b {
		return 1
	} else if a < b {
		return -1
	} else {
		return 0
	}
}


func testChain () -> Bool {
	if compare(5, 3) != 1 {
		printf("compare(5, 3) = %d, expected 1\n", compare(5, 3))
		return false
	}

	if compare(3, 5) != -1 {
		printf("compare(3, 5) = %d, expected -1\n", compare(3, 5))
		return false
	}

	if compare(4, 4) != 0 {
		printf("compare(4, 4) = %d, expected 0\n", compare(4, 4))
		return false
	}

	printf("passed: if chain\n")
	return true
}


// No `else` anywhere: each branch is independent.
func countPositive (a: Int32, b: Int32, c: Int32) -> Int32 {
	var n: Int32 = 0
	if a > 0 {
		++n
	}
	if b > 0 {
		++n
	}
	if c > 0 {
		++n
	}
	return n
}


func testNoElse () -> Bool {
	if countPositive(1, -1, 3) != 2 {
		printf("countPositive(1, -1, 3) = %d, expected 2\n", countPositive(1, -1, 3))
		return false
	}

	if countPositive(-1, -2, -3) != 0 {
		printf("countPositive(-1, -2, -3) = %d, expected 0\n", countPositive(-1, -2, -3))
		return false
	}

	printf("passed: if without else\n")
	return true
}


func testExplicitConditions () -> Bool {
	let zero: Int32 = 0
	var taken = false

	// A zero number is not a false condition — it is not a condition at all.
	if zero != 0 {
		taken = true
	}
	if taken {
		printf("zero != 0 was true\n")
		return false
	}

	var p: *Int32 = nil
	if p != nil {
		printf("nil pointer compared unequal to nil\n")
		return false
	}

	var n: Int32 = 7
	p = &n
	if p == nil {
		printf("pointer to a local compared equal to nil\n")
		return false
	}

	// Bool values stand on their own, without a comparison.
	let ready = true
	if not ready {
		printf("`not true` was true\n")
		return false
	}

	printf("passed: explicit conditions\n")
	return true
}


func main () -> Int {
	var result = true
	result = testChain() and result
	result = testNoElse() and result
	result = testExplicitConditions() and result

	if not result {
		printf("failed: if\n")
		return exitFailure
	}

	printf("passed: if\n")
	return exitSuccess
}
