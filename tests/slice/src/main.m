// tests/slice/src/main.m
//
// See docs/lang/value/slice.md for documented slice semantics and
// docs/BUGS.md #3 for a known slice-assignment codegen bug.

include "libc/ctypes64"
include "libc/stdlib"
include "libc/stdio"
include "limits"


func array4intInc (a: [4]Int32) -> [4]Int32 {
	return [a[0]+1, a[1]+1, a[2]+1, a[3]+1]
}


func sum4 (a: [4]Int32) -> Int32 {
	return a[0] + a[1] + a[2] + a[3]
}


//
// 1. read a slice, literal bounds
//

func testReadLiteralBounds () -> Bool {
	var a: [5]Int32 = [10, 20, 30, 40, 50]
	let s = a[1:4]
	let expected = [3]Int32 [20, 30, 40]

	if lengthof(s) != 3 {
		printf("FAIL testReadLiteralBounds: wrong length\n")
		return false
	}
	if s != expected {
		printf("FAIL testReadLiteralBounds: wrong contents\n")
		return false
	}
	printf("passed: read slice, literal bounds\n")
	return true
}


//
// 2. read a slice, bounds come from `let` (not compile-time literals)
//

func testReadRuntimeBounds () -> Bool {
	var a: [5]Int32 = [10, 20, 30, 40, 50]
	let i = 1
	let j = 4
	let s = a[i:j]
	let expected = [3]Int32 [20, 30, 40]

	if lengthof(s) != 3 {
		printf("FAIL testReadRuntimeBounds: wrong length\n")
		return false
	}
	if s != expected {
		printf("FAIL testReadRuntimeBounds: wrong contents\n")
		return false
	}
	printf("passed: read slice, runtime bounds\n")
	return true
}


//
// 3. read a slice through a pointer to array (auto-deref)
//

func testReadViaPointer () -> Bool {
	var a: [5]Int32 = [10, 20, 30, 40, 50]
	let pa = &a
	let s = pa[1:4]
	let expected = [3]Int32 [20, 30, 40]

	if lengthof(s) != 3 {
		printf("FAIL testReadViaPointer: wrong length\n")
		return false
	}
	if s != expected {
		printf("FAIL testReadViaPointer: wrong contents\n")
		return false
	}
	printf("passed: read slice via pointer to array\n")
	return true
}


//
// 4. empty slice: from == to
//

func testEmptySlice () -> Bool {
	var a: [5]Int32 = [10, 20, 30, 40, 50]
	let s = a[2:2]

	if lengthof(s) != 0 {
		printf("FAIL testEmptySlice: expected length 0\n")
		return false
	}
	printf("passed: empty slice\n")
	return true
}


//
// 5. full-range slice
//

func testFullRangeSlice () -> Bool {
	var a: [5]Int32 = [10, 20, 30, 40, 50]
	let s = a[0:lengthof(a)]

	if lengthof(s) != lengthof(a) {
		printf("FAIL testFullRangeSlice: wrong length\n")
		return false
	}
	if s != a {
		printf("FAIL testFullRangeSlice: wrong contents\n")
		return false
	}
	printf("passed: full range slice\n")
	return true
}


//
// 6. slice of an unsized array
//

func testUnsizedArraySlice () -> Bool {
	var a = []Int32 [10, 20, 30, 40, 50]
	let s = a[1:4]
	let expected = [3]Int32 [20, 30, 40]

	if lengthof(s) != 3 {
		printf("FAIL testUnsizedArraySlice: wrong length\n")
		return false
	}
	if s != expected {
		printf("FAIL testUnsizedArraySlice: wrong contents\n")
		return false
	}
	printf("passed: slice of unsized array\n")
	return true
}


//
// 7. slice as a function argument (pass-by-value)
//

func testSliceAsFuncArg () -> Bool {
	var a: [8]Int32 = [1, 2, 3, 4, 5, 6, 7, 8]

	if sum4(a[0:4]) != 10 {
		printf("FAIL testSliceAsFuncArg: wrong sum for first half\n")
		return false
	}
	if sum4(a[4:8]) != 26 {
		printf("FAIL testSliceAsFuncArg: wrong sum for second half\n")
		return false
	}
	printf("passed: slice as function argument\n")
	return true
}


//
// 8. slice assignment from a function's return value
//

func testSliceAssignFromCall () -> Bool {
	var a: [8]Int32 = [0, 1, 2, 3, 4, 5, 6, 7]
	a[0:4] = array4intInc(a[0:4])
	a[4:8] = array4intInc(a[4:8])

	let expected = [8]Int32 [1, 2, 3, 4, 5, 6, 7, 8]
	if a != expected {
		printf("FAIL testSliceAssignFromCall: wrong contents\n")
		return false
	}
	printf("passed: slice assignment from function return\n")
	return true
}


//
// 9. slice assignment from an array literal, literal bounds
//    docs/lang/value/slice.md: `a[0:2] = [2]Int32 [9, 9]`
//    known bug: docs/BUGS.md #3
//

func testSliceAssignFromLiteral () -> Bool {
	var a: [5]Int32 = [0, 0, 0, 0, 0]
	a[1:4] = [3]Int32 [7, 8, 9]

	let expected = [5]Int32 [0, 7, 8, 9, 0]
	if a != expected {
		printf("FAIL testSliceAssignFromLiteral: wrong contents (see docs/BUGS.md #3)\n")
		return false
	}
	printf("passed: slice assignment from array literal\n")
	return true
}


//
// 10. same as above, but bounds come from `let` variables, not literals
//

func testSliceAssignFromLiteralRuntimeBounds () -> Bool {
	var a: [5]Int32 = [0, 0, 0, 0, 0]
	let i = 1
	let j = 4
	a[i:j] = [3]Int32 [7, 8, 9]

	let expected = [5]Int32 [0, 7, 8, 9, 0]
	if a != expected {
		printf("FAIL testSliceAssignFromLiteralRuntimeBounds: wrong contents (see docs/BUGS.md #3)\n")
		return false
	}
	printf("passed: slice assignment from array literal, runtime bounds\n")
	return true
}


//
// 11. slice assignment with a wider element type
//     (checks whether the byte-count bug in #9/#10 scales with element size)
//

func testSliceAssignWiderElementType () -> Bool {
	var a: [4]Nat64 = [0, 0, 0, 0]
	a[1:3] = [2]Nat64 [111, 222]

	let expected = [4]Nat64 [0, 111, 222, 0]
	if a != expected {
		printf("FAIL testSliceAssignWiderElementType: wrong contents (see docs/BUGS.md #3)\n")
		return false
	}
	printf("passed: slice assignment, wider element type\n")
	return true
}


func main () -> Int32 {
	printf("test slice\n")

	var result = true
	result = testReadLiteralBounds() and result
	result = testReadRuntimeBounds() and result
	result = testReadViaPointer() and result
	result = testEmptySlice() and result
	result = testFullRangeSlice() and result
	result = testUnsizedArraySlice() and result
	result = testSliceAsFuncArg() and result
	result = testSliceAssignFromCall() and result
	result = testSliceAssignFromLiteral() and result
	result = testSliceAssignFromLiteralRuntimeBounds() and result
	result = testSliceAssignWiderElementType() and result

	printf("test ")
	if not result {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}
