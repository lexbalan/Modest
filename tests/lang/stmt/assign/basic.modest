// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: variable assign
// EXPECT-OUT: passed: array assign
// EXPECT-OUT: passed: slice assign
// EXPECT-OUT: passed: field assign
// EXPECT-OUT: passed: deref assign
// EXPECT-OUT: passed: increment
// EXPECT-OUT: passed: assign
//
// Covers every lvalue form of the assignment statement, plus `++` / `--`.
// Modest has no compound assignment (`+=`), so counting is written as
// `x = x + 1`; increment and decrement are statements, not expressions.

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


type Point = {
	x: Int32
	y: Int32
}


func testVariable () -> Bool {
	var x: Int32 = 1
	x = 10
	if x != 10 {
		printf("x = %d, expected 10\n", x)
		return false
	}

	// No `+=`: the long form is the only form.
	x = x + 5
	if x != 15 {
		printf("x = %d, expected 15\n", x)
		return false
	}

	// The right-hand side is constructed to the lvalue's type: the literal
	// 42 is a compile-time Integer, and lands here as Int32.
	x = 42
	if x != 42 {
		printf("x = %d, expected 42\n", x)
		return false
	}

	printf("passed: variable assign\n")
	return true
}


func testArrayElement () -> Bool {
	var arr: [5]Int32 = [1, 2, 3, 4, 5]

	arr[0] = 100
	if arr[0] != 100 {
		printf("arr[0] = %d, expected 100\n", arr[0])
		return false
	}

	// Index by a runtime value, not just a literal.
	var i: Int32 = 4
	arr[i] = 500
	if arr[4] != 500 {
		printf("arr[4] = %d, expected 500\n", arr[4])
		return false
	}

	// Untouched elements keep their value.
	if arr[2] != 3 {
		printf("arr[2] = %d, expected 3\n", arr[2])
		return false
	}

	printf("passed: array assign\n")
	return true
}


func testSlice () -> Bool {
	var arr: [5]Int32 = [1, 2, 3, 4, 5]

	arr[1:4] = [3]Int32 [7, 8, 9]

	if arr[0] != 1 {
		printf("arr[0] = %d, expected 1 (before the slice)\n", arr[0])
		return false
	}
	if arr[1] != 7 or arr[2] != 8 or arr[3] != 9 {
		printf("arr[1:4] = [%d, %d, %d], expected [7, 8, 9]\n", arr[1], arr[2], arr[3])
		return false
	}
	if arr[4] != 5 {
		printf("arr[4] = %d, expected 5 (after the slice)\n", arr[4])
		return false
	}

	printf("passed: slice assign\n")
	return true
}


func testField () -> Bool {
	var pt = Point {x = 1, y = 2}

	pt.x = 30
	if pt.x != 30 {
		printf("pt.x = %d, expected 30\n", pt.x)
		return false
	}

	// Through a pointer the field is reached with `.`, not `->`.
	let p = &pt
	p.y = 40
	if pt.y != 40 {
		printf("pt.y = %d, expected 40 after write through pointer\n", pt.y)
		return false
	}

	printf("passed: field assign\n")
	return true
}


func testDeref () -> Bool {
	var n: Int32 = 1
	let p = &n

	*p = 99
	if n != 99 {
		printf("n = %d, expected 99 after *p = 99\n", n)
		return false
	}

	printf("passed: deref assign\n")
	return true
}


func testIncrement () -> Bool {
	var i: Int32 = 5

	++i
	if i != 6 {
		printf("i = %d, expected 6 after ++i\n", i)
		return false
	}

	--i
	--i
	if i != 4 {
		printf("i = %d, expected 4 after two --i\n", i)
		return false
	}

	printf("passed: increment\n")
	return true
}


func main () -> Int {
	var result = true
	result = testVariable() and result
	result = testArrayElement() and result
	result = testSlice() and result
	result = testField() and result
	result = testDeref() and result
	result = testIncrement() and result

	if not result {
		printf("failed: assign\n")
		return exitFailure
	}

	printf("passed: assign\n")
	return exitSuccess
}
