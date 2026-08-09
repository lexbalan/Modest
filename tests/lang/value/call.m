// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: positional
// EXPECT-OUT: passed: named
// EXPECT-OUT: passed: defaults
// EXPECT-OUT: passed: through pointer
// EXPECT-OUT: passed: argument construction
// EXPECT-OUT: passed: nested calls
// EXPECT-OUT: passed: record argument
// EXPECT-OUT: passed: array argument
// EXPECT-OUT: passed: composite arguments
// EXPECT-OUT: passed: laid out arguments
// EXPECT-OUT: passed: call
//
// Covers the call expression end to end: how arguments are written
// (positional, named, defaulted), how they are typed (implicit
// construction), how the callee is named (directly, through a pointer to
// function), and how composite arguments travel — by value, like every
// other value in Modest.

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


type Point = {
	x: Int32
	y: Int32
}


type Packed = @layout("packed") {
	flag: Bool
	value: Int32
}


type Overlay = @layout("union") {
	word: Word32
	low: Word8
}


type Op = *(a: Int32, b: Int32) -> Int32


var sharedPoint: Point
var sharedTable: [3]Int32


func area (w: Int32, h: Int32 = 1) -> Int32 {
	return w * h
}


func testPositional () -> Bool {
	if area(3, 4) != 12 {
		printf("area(3, 4) = %d, expected 12\n", area(3, 4))
		return false
	}

	printf("passed: positional\n")
	return true
}


func testNamed () -> Bool {
	// Named arguments may come in any order...
	if area(h = 4, w = 3) != 12 {
		printf("area(h = 4, w = 3) = %d, expected 12\n", area(h = 4, w = 3))
		return false
	}

	// ...and may follow positional ones.
	if area(3, h = 4) != 12 {
		printf("area(3, h = 4) = %d, expected 12\n", area(3, h = 4))
		return false
	}

	printf("passed: named\n")
	return true
}


func testDefaults () -> Bool {
	// h defaults to 1.
	if area(5) != 5 {
		printf("area(5) = %d, expected 5\n", area(5))
		return false
	}

	// An explicit argument wins over the default.
	if area(5, 3) != 15 {
		printf("area(5, 3) = %d, expected 15\n", area(5, 3))
		return false
	}

	printf("passed: defaults\n")
	return true
}


func add (a: Int32, b: Int32) -> Int32 {
	return a + b
}


func sub (a: Int32, b: Int32) -> Int32 {
	return a - b
}


func testThroughPointer () -> Bool {
	var op: Op = &add
	if op(10, 4) != 14 {
		printf("op(10, 4) = %d, expected 14 through &add\n", op(10, 4))
		return false
	}

	// The same call site reaches a different function.
	op = &sub
	if op(10, 4) != 6 {
		printf("op(10, 4) = %d, expected 6 through &sub\n", op(10, 4))
		return false
	}

	printf("passed: through pointer\n")
	return true
}


func wide (n: Int64) -> Int64 {
	return n
}


func real (f: Float64) -> Float64 {
	return f
}


func testArgumentConstruction () -> Bool {
	// Arguments are constructed to the parameter type: the compile-time
	// Integer and Rational literals land as Int64 and Float64.
	if wide(42) != 42 {
		printf("wide(42) returned the wrong value, expected 42\n")
		return false
	}

	if real(1.5) != 1.5 {
		printf("real(1.5) = %f, expected 1.5\n", real(1.5))
		return false
	}

	printf("passed: argument construction\n")
	return true
}


func twice (n: Int32) -> Int32 {
	return n * 2
}


func testNestedCalls () -> Bool {
	// A call result used directly as an argument, with nothing holding it.
	if twice(twice(3)) != 12 {
		printf("twice(twice(3)) = %d, expected 12\n", twice(twice(3)))
		return false
	}

	if add(twice(2), area(2, 3)) != 10 {
		printf("add(twice(2), area(2, 3)) = %d, expected 10\n",
			add(twice(2), area(2, 3)))
		return false
	}

	printf("passed: nested calls\n")
	return true
}


// Writes to the global after the argument was passed. If the record
// travelled by reference, the parameter would see the new value.
func observePoint (p: Point) -> Int32 {
	sharedPoint.x = 99
	return p.x
}


func testRecordArgument () -> Bool {
	sharedPoint = Point {x = 1, y = 2}

	if observePoint(sharedPoint) != 1 {
		printf("record argument aliased the caller's value\n")
		return false
	}

	// The write inside did land — the callee touched the global, not a copy.
	if sharedPoint.x != 99 {
		printf("sharedPoint.x = %d, expected 99\n", sharedPoint.x)
		return false
	}

	printf("passed: record argument\n")
	return true
}


func observeTable (a: [3]Int32) -> Int32 {
	sharedTable[0] = 99
	return a[0]
}


func testArrayArgument () -> Bool {
	sharedTable = [3]Int32 [1, 2, 3]

	// Arrays do not decay to pointers on the way in.
	if observeTable(sharedTable) != 1 {
		printf("array argument aliased the caller's value\n")
		return false
	}

	if sharedTable[0] != 99 {
		printf("sharedTable[0] = %d, expected 99\n", sharedTable[0])
		return false
	}

	printf("passed: array argument\n")
	return true
}


func firstOf (arr: [2]Point) -> Int32 {
	return arr[0].x
}


func secondOf (arr: [2]Point) -> Int32 {
	return arr[1].x
}


func testCompositeArguments () -> Bool {
	let pts = [2]Point [Point {x = 7, y = 0}, Point {x = 8, y = 0}]

	if firstOf(pts) != 7 {
		printf("firstOf(pts) = %d, expected 7\n", firstOf(pts))
		return false
	}
	if secondOf(pts) != 8 {
		printf("secondOf(pts) = %d, expected 8\n", secondOf(pts))
		return false
	}

	printf("passed: composite arguments\n")
	return true
}


func takePacked (p: Packed) -> Int32 {
	return p.value
}


func takeOverlay (o: Overlay) -> Word32 {
	return o.word
}


// A record's layout attribute changes how it sits in memory, which is
// exactly what argument passing has to get right.
func testLaidOutArguments () -> Bool {
	if takePacked(Packed {flag = true, value = 42}) != 42 {
		printf("takePacked(...) = %d, expected 42\n",
			takePacked(Packed {flag = true, value = 42}))
		return false
	}

	// Read back the same field that was written — no byte-order assumption.
	let w = Word32 0x12345678
	if takeOverlay(Overlay {word = w}) != w {
		printf("takeOverlay(...) did not return the word it was given\n")
		return false
	}

	printf("passed: laid out arguments\n")
	return true
}


func main () -> Int {
	var result = true
	result = testPositional() and result
	result = testNamed() and result
	result = testDefaults() and result
	result = testThroughPointer() and result
	result = testArgumentConstruction() and result
	result = testNestedCalls() and result
	result = testRecordArgument() and result
	result = testArrayArgument() and result
	result = testCompositeArguments() and result
	result = testLaidOutArguments() and result

	if not result {
		printf("failed: call\n")
		return exitFailure
	}

	printf("passed: call\n")
	return exitSuccess
}
