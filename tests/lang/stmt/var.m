// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: var forms
// EXPECT-OUT: passed: var inference
// EXPECT-OUT: passed: global zero init
// EXPECT-OUT: passed: explicit zeroing
// EXPECT-OUT: passed: var
//
// Covers the local variable statement: the declaration forms, type
// inference, and the split between globals (zero-initialized) and locals
// (must be assigned before use).

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


type Point = {
	x: Int32
	y: Int32
}


// Globals are zero-initialized; no initializer needed.
var globalCounter: Int32
var globalArray: [3]Int32
var globalPoint: Point
var globalFlag: Bool
var globalPtr: *Int32


func testForms () -> Bool {
	// Declared, then assigned before first use.
	var a: Int32
	a = 1

	// Declared with an initializer.
	var b: Int32 = 2

	// Declared with an explicit type and assigned from an expression.
	var c: Int32
	c = a + b * 10

	if a != 1 or b != 2 {
		printf("a = %d, b = %d, expected 1, 2\n", a, b)
		return false
	}
	if c != 21 {
		printf("c = %d, expected 21\n", c)
		return false
	}

	printf("passed: var forms\n")
	return true
}


func testInference () -> Bool {
	// The type comes from the initializer.
	var flag = true
	var f = 1.5
	var pt = Point {x = 3, y = 4}

	if not flag {
		printf("flag inferred from `true` is false\n")
		return false
	}
	if f * 2.0 != 3.0 {
		printf("f * 2.0 = %f, expected 3.0\n", f * 2.0)
		return false
	}
	if pt.x != 3 or pt.y != 4 {
		printf("pt = {%d, %d}, expected {3, 4}\n", pt.x, pt.y)
		return false
	}

	// An initializer may be any runtime expression.
	var n: Int32 = 6
	var doubled = n * 2
	if doubled != 12 {
		printf("doubled = %d, expected 12\n", doubled)
		return false
	}

	printf("passed: var inference\n")
	return true
}


func testGlobalZeroInit () -> Bool {
	if globalCounter != 0 {
		printf("globalCounter = %d, expected 0\n", globalCounter)
		return false
	}
	if globalFlag {
		printf("globalFlag is true, expected false\n")
		return false
	}
	if globalPtr != nil {
		printf("globalPtr is not nil\n")
		return false
	}
	if globalArray[0] != 0 or globalArray[1] != 0 or globalArray[2] != 0 {
		printf("globalArray = [%d, %d, %d], expected all zero\n",
			globalArray[0], globalArray[1], globalArray[2])
		return false
	}
	if globalPoint.x != 0 or globalPoint.y != 0 {
		printf("globalPoint = {%d, %d}, expected {0, 0}\n", globalPoint.x, globalPoint.y)
		return false
	}

	// And a global is writable like any other variable.
	globalCounter = 5
	if globalCounter != 5 {
		printf("globalCounter = %d, expected 5 after assignment\n", globalCounter)
		return false
	}

	printf("passed: global zero init\n")
	return true
}


func testExplicitZeroing () -> Bool {
	// Locals get no implicit zero — these are the explicit forms.
	var n: Int32 = 0
	var arr: [3]Int32 = []
	var pt: Point = {}

	if n != 0 {
		printf("n = %d, expected 0\n", n)
		return false
	}
	if arr[0] != 0 or arr[1] != 0 or arr[2] != 0 {
		printf("arr = [%d, %d, %d], expected all zero\n", arr[0], arr[1], arr[2])
		return false
	}
	if pt.x != 0 or pt.y != 0 {
		printf("pt = {%d, %d}, expected {0, 0}\n", pt.x, pt.y)
		return false
	}

	printf("passed: explicit zeroing\n")
	return true
}


func main () -> Int {
	var result = true
	result = testForms() and result
	result = testInference() and result
	result = testGlobalZeroInit() and result
	result = testExplicitZeroing() and result

	if not result {
		printf("failed: var\n")
		return exitFailure
	}

	printf("passed: var\n")
	return exitSuccess
}
