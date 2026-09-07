// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: statement order
// EXPECT-OUT: passed: block scope
// EXPECT-OUT: passed: local definitions
// EXPECT-OUT: passed: block
//
// Covers blocks: statements run top to bottom, and a name defined in a
// block lives from its definition to the end of that block. Blocks are
// bodies of functions, `if` branches and `while` loops — never standalone.

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


func testOrder () -> Bool {
	var log: [4]Int32 = []
	var n: Int32 = 0

	log[n] = 1
	++n
	log[n] = 2
	++n
	log[n] = 3
	++n

	if n != 3 {
		printf("n = %d, expected 3\n", n)
		return false
	}
	if log[0] != 1 or log[1] != 2 or log[2] != 3 {
		printf("log = [%d, %d, %d], expected [1, 2, 3]\n", log[0], log[1], log[2])
		return false
	}

	// The last slot was never written, so it kept its zero.
	if log[3] != 0 {
		printf("log[3] = %d, expected 0\n", log[3])
		return false
	}

	printf("passed: statement order\n")
	return true
}


func testScope () -> Bool {
	var total: Int32 = 0        // visible to the end of the function

	if total == 0 {
		let inBranch = 10       // visible to the end of this branch
		total = total + inBranch
	}

	var i: Int32 = 0
	while i < 3 {
		let inLoop = i * 2      // fresh binding on every iteration
		total = total + inLoop
		++i
	}

	// 10 + (0 + 2 + 4)
	if total != 16 {
		printf("total = %d, expected 16\n", total)
		return false
	}

	printf("passed: block scope\n")
	return true
}


func testLocalDefinitions () -> Bool {
	// A block may define types and functions, not just values.
	type Pair = {
		a: Int32
		b: Int32
	}

	func twice (n: Int32) -> Int32 {
		return n * 2
	}

	// Fields of a local record are reachable like any other in the module:
	// privacy is enforced across modules, not across blocks.
	let p = Pair {a = 3, b = 4}
	if p.a + p.b != 7 {
		printf("p.a + p.b = %d, expected 7\n", p.a + p.b)
		return false
	}

	if twice(21) != 42 {
		printf("twice(21) = %d, expected 42\n", twice(21))
		return false
	}

	printf("passed: local definitions\n")
	return true
}


func main () -> Int {
	var result = true
	result = testOrder() and result
	result = testScope() and result
	result = testLocalDefinitions() and result

	if not result {
		printf("failed: block\n")
		return exitFailure
	}

	printf("passed: block\n")
	return exitSuccess
}
