// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: break exits
// EXPECT-OUT: passed: again restarts
// EXPECT-OUT: passed: innermost loop
// EXPECT-OUT: passed: break_again
//
// Covers `break` and `again` where it matters: there are no loop labels,
// so both always act on the nearest enclosing `while` — the outer loop of
// a nested pair keeps running.

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


func testBreakExits () -> Bool {
	// `while true` is only escapable by `break`.
	var i: Int32 = 0
	while true {
		++i
		if i == 3 {
			break
		}
	}

	if i != 3 {
		printf("i = %d, expected 3\n", i)
		return false
	}

	// Statements after the `break` in the same body never run.
	var reached: Bool = false
	var n: Int32 = 0
	while n < 10 {
		break
		reached = true
	}

	if reached {
		printf("code after `break` was reached\n")
		return false
	}
	if n != 0 {
		printf("n = %d, expected 0 — the body ran past the break\n", n)
		return false
	}

	printf("passed: break exits\n")
	return true
}


func testAgainRestarts () -> Bool {
	// `again` jumps back to the condition, skipping the rest of the body.
	var i: Int32 = 0
	var skipped: Int32 = 0
	var counted: Int32 = 0

	while i < 6 {
		let cur = i
		++i
		if cur < 3 {
			skipped = skipped + 1
			again
		}
		counted = counted + 1
	}

	if skipped != 3 {
		printf("skipped = %d, expected 3\n", skipped)
		return false
	}
	if counted != 3 {
		printf("counted = %d, expected 3\n", counted)
		return false
	}

	printf("passed: again restarts\n")
	return true
}


// Counts pairs (i, j) visited in a nested loop where the inner one is cut
// short. If `break` reached the outer loop, the total would be 1.
func testInnermost () -> Bool {
	var visits: Int32 = 0
	var outerRounds: Int32 = 0

	var i: Int32 = 0
	while i < 3 {
		var j: Int32 = 0
		while j < 5 {
			++visits
			if j == 1 {
				break        // leaves the inner loop only
			}
			++j
		}
		outerRounds = outerRounds + 1
		++i
	}

	if outerRounds != 3 {
		printf("outerRounds = %d, expected 3 — break escaped the outer loop\n", outerRounds)
		return false
	}
	if visits != 6 {
		printf("visits = %d, expected 6 (2 per outer round)\n", visits)
		return false
	}

	// The same for `again`: it restarts the inner loop, not the outer one.
	var inner: Int32 = 0
	var outer: Int32 = 0
	i = 0
	while i < 2 {
		var j: Int32 = 0
		while j < 4 {
			++j
			if j == 2 {
				again        // restarts the inner loop
			}
			++inner
		}
		++outer
		++i
	}

	if outer != 2 {
		printf("outer = %d, expected 2\n", outer)
		return false
	}
	if inner != 6 {
		printf("inner = %d, expected 6 (3 per outer round)\n", inner)
		return false
	}

	printf("passed: innermost loop\n")
	return true
}


func main () -> Int {
	var result = true
	result = testBreakExits() and result
	result = testAgainRestarts() and result
	result = testInnermost() and result

	if not result {
		printf("failed: break_again\n")
		return exitFailure
	}

	printf("passed: break_again\n")
	return exitSuccess
}
