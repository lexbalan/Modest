// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: while sum
// EXPECT-OUT: passed: break
// EXPECT-OUT: passed: again
// EXPECT-OUT: passed: while
//
// Covers the `while` statement and the two ways out of an iteration:
// `break` leaves the loop, `again` starts the next one (Modest has no
// `continue`, and no `for` at all — every loop is a `while`).

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


func sumTo (n: Int32) -> Int32 {
	var total: Int32 = 0
	var i: Int32 = 0
	while i < n {
		total = total + i
		++i
	}
	return total
}


func testWhileSum () -> Bool {
	if sumTo(5) != 10 {
		printf("sumTo(5) = %d, expected 10\n", sumTo(5))
		return false
	}

	// A condition that is false on entry must skip the body entirely.
	if sumTo(0) != 0 {
		printf("sumTo(0) = %d, expected 0\n", sumTo(0))
		return false
	}

	printf("passed: while sum\n")
	return true
}


// Smallest i whose square exceeds limit; `break` stops the scan.
func firstSquareOver (limit: Int32) -> Int32 {
	var i: Int32 = 0
	while i < 100 {
		if i * i > limit {
			break
		}
		++i
	}
	return i
}


func testBreak () -> Bool {
	if firstSquareOver(50) != 8 {
		printf("firstSquareOver(50) = %d, expected 8\n", firstSquareOver(50))
		return false
	}

	printf("passed: break\n")
	return true
}


// Sum of the odd numbers below n; `again` skips the even ones.
func sumOdd (n: Int32) -> Int32 {
	var total: Int32 = 0
	var i: Int32 = 0
	while i < n {
		let cur = i
		++i  // step before `again`, or the loop never advances
		if cur % 2 == 0 {
			again
		}
		total = total + cur
	}
	return total
}


func testAgain () -> Bool {
	if sumOdd(10) != 25 {
		printf("sumOdd(10) = %d, expected 25\n", sumOdd(10))
		return false
	}

	printf("passed: again\n")
	return true
}


func main () -> Int {
	var result = true
	result = testWhileSum() and result
	result = testBreak() and result
	result = testAgain() and result

	if not result {
		printf("failed: while\n")
		return exitFailure
	}

	printf("passed: while\n")
	return exitSuccess
}
