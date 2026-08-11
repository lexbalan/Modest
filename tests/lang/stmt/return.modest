// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: return value
// EXPECT-OUT: passed: return construction
// EXPECT-OUT: passed: return record
// EXPECT-OUT: passed: return array
// EXPECT-OUT: passed: unit return
// EXPECT-OUT: passed: return
//
// Covers the `return` statement: returning a value, the implicit
// construction of that value to the declared return type, composite
// return types (records and arrays, which travel by value), and the bare
// `return` of a Unit function (which may also be left out entirely).

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


type Point = {
	x: Int32
	y: Int32
}

// Wide enough that the C ABI hands it back through hidden storage rather
// than a register — a different path in both backends than Point takes.
type Wide = {
	a: Int64
	b: Int64
	c: Int64
	d: Int64
}


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


var sharedPoint: Point
var sharedTable: [3]Int32


func makePoint (x: Int32, y: Int32) -> Point {
	return Point {x = x, y = y}
}


func makeWide () -> Wide {
	return Wide {a = 1, b = 2, c = 3, d = 4}
}


func getSharedPoint () -> Point {
	return sharedPoint
}


func testRecord () -> Bool {
	let p = makePoint(3, 4)
	if p.x != 3 or p.y != 4 {
		printf("makePoint(3, 4) = {%d, %d}, expected {3, 4}\n", p.x, p.y)
		return false
	}

	// A field read straight off the call result, with nothing to hold it.
	if makePoint(7, 8).y != 8 {
		printf("makePoint(7, 8).y = %d, expected 8\n", makePoint(7, 8).y)
		return false
	}

	let w = makeWide()
	if w.a != 1 or w.d != 4 {
		printf("makeWide() = {%lld, ..., %lld}, expected {1, ..., 4}\n", w.a, w.d)
		return false
	}

	// The record comes back by value: the caller's copy is its own.
	sharedPoint = Point {x = 1, y = 2}
	var copy = getSharedPoint()
	copy.x = 99
	if sharedPoint.x != 1 {
		printf("sharedPoint.x = %d, expected 1 — the return aliased the source\n",
			sharedPoint.x)
		return false
	}
	if copy.x != 99 {
		printf("copy.x = %d, expected 99\n", copy.x)
		return false
	}

	printf("passed: return record\n")
	return true
}


func makeArray () -> [4]Int32 {
	return [4]Int32 [10, 20, 30, 40]
}


// The array is built in this frame and must outlive it.
func localArray () -> [3]Int32 {
	var tmp: [3]Int32 = [7, 8, 9]
	return tmp
}


func getSharedTable () -> [3]Int32 {
	return sharedTable
}


func testArray () -> Bool {
	// Arrays are values in Modest — no decay to a pointer on the way out.
	let a = makeArray()
	if a[0] != 10 or a[3] != 40 {
		printf("makeArray() = [%d, ..., %d], expected [10, ..., 40]\n", a[0], a[3])
		return false
	}

	let loc = localArray()
	if loc[0] != 7 or loc[1] != 8 or loc[2] != 9 {
		printf("localArray() = [%d, %d, %d], expected [7, 8, 9]\n",
			loc[0], loc[1], loc[2])
		return false
	}

	// By value here too: writing to the returned array leaves the global be.
	sharedTable = [3]Int32 [1, 2, 3]
	var copy = getSharedTable()
	copy[0] = 99
	if sharedTable[0] != 1 {
		printf("sharedTable[0] = %d, expected 1 — the return aliased the source\n",
			sharedTable[0])
		return false
	}
	if copy[0] != 99 {
		printf("copy[0] = %d, expected 99\n", copy[0])
		return false
	}

	printf("passed: return array\n")
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
	result = testRecord() and result
	result = testArray() and result
	result = testUnit() and result

	if not result {
		printf("failed: return\n")
		return exitFailure
	}

	printf("passed: return\n")
	return exitSuccess
}
