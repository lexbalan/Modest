// tests/sizeof/src/main.m

pragma unsafe

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


func testUnit () -> Bool {
	if sizeof(Unit) != 0 {
		printf("error: sizeof(Unit) != 0\n")
		return false
	}

	if alignof(Unit) != 1 {
		printf("error: alignof(Unit) != 1\n")
		return false
	}

	printf("passed: testUnit\n")
	return true
}


func testBool () -> Bool {
	if sizeof(Bool) != 1 {
		printf("error: sizeof(Bool) != 1\n")
		return false
	}

	if alignof(Bool) != 1 {
		printf("error: alignof(Bool) != 1\n")
		return false
	}

	printf("passed: testBool\n")
	return true
}


func testWord () -> Bool {
	if sizeof(Word8) != 1 {
		printf("error: sizeof(Word8) != 1\n")
		return false
	}

	if sizeof(Word16) != 2 {
		printf("error: sizeof(Word16) != 2\n")
		return false
	}

	if sizeof(Word32) != 4 {
		printf("error: sizeof(Word32) != 4\n")
		return false
	}

	if sizeof(Word64) != 8 {
		printf("error: sizeof(Word64) != 8\n")
		return false
	}


	if alignof(Word8) != 1 {
		printf("error: alignof(Word8) != 1\n")
		return false
	}

	if alignof(Word16) != 2 {
		printf("error: alignof(Word16) != 2\n")
		return false
	}

	if alignof(Word32) != 4 {
		printf("error: alignof(Word32) != 4\n")
		return false
	}

	if alignof(Word64) != 8 {
		printf("error: alignof(Word64) != 8\n")
		return false
	}


	printf("passed: testWord\n")
	return true
}


func testInt () -> Bool {
	if sizeof(Int8) != 1 {
		printf("error: sizeof(Int8) != 1\n")
		return false
	}

	if sizeof(Int16) != 2 {
		printf("error: sizeof(Int16) != 2\n")
		return false
	}

	if sizeof(Int32) != 4 {
		printf("error: sizeof(Int32) != 4\n")
		return false
	}

	if sizeof(Int64) != 8 {
		printf("error: sizeof(Int64) != 8\n")
		return false
	}


	if alignof(Int8) != 1 {
		printf("error: alignof(Int8) != 1\n")
		return false
	}

	if alignof(Int16) != 2 {
		printf("error: alignof(Int16) != 2\n")
		return false
	}

	if alignof(Int32) != 4 {
		printf("error: alignof(Int32) != 4\n")
		return false
	}

	if alignof(Int64) != 8 {
		printf("error: alignof(Int64) != 8\n")
		return false
	}


	printf("passed: testInt\n")
	return true
}


func testNat () -> Bool {
	if sizeof(Nat8) != 1 {
		printf("error: sizeof(Nat8) != 1\n")
		return false
	}

	if sizeof(Nat16) != 2 {
		printf("error: sizeof(Nat16) != 2\n")
		return false
	}

	if sizeof(Nat32) != 4 {
		printf("error: sizeof(Nat32) != 4\n")
		return false
	}

	if sizeof(Nat64) != 8 {
		printf("error: sizeof(Nat64) != 8\n")
		return false
	}


	if alignof(Nat8) != 1 {
		printf("error: alignof(Nat8) != 1\n")
		return false
	}

	if alignof(Nat16) != 2 {
		printf("error: alignof(Nat16) != 2\n")
		return false
	}

	if alignof(Nat32) != 4 {
		printf("error: alignof(Nat32) != 4\n")
		return false
	}

	if alignof(Nat64) != 8 {
		printf("error: alignof(Nat64) != 8\n")
		return false
	}


	printf("passed: testNat\n")
	return true
}


func testChar () -> Bool {
	if sizeof(Char8) != 1 {
		printf("error: sizeof(Char8) != 1\n")
		return false
	}

	if sizeof(Char16) != 2 {
		printf("error: sizeof(Char16) != 2\n")
		return false
	}

	if sizeof(Char32) != 4 {
		printf("error: sizeof(Char32) != 4\n")
		return false
	}


	if alignof(Char8) != 1 {
		printf("error: alignof(Char8) != 1\n")
		return false
	}

	if alignof(Char16) != 2 {
		printf("error: alignof(Char16) != 2\n")
		return false
	}

	if alignof(Char32) != 4 {
		printf("error: alignof(Char32) != 4\n")
		return false
	}


	printf("passed: testChar\n")
	return true
}


func testFloat () -> Bool {
	if sizeof(Float32) != 4 {
		printf("error: sizeof(Float32) != 4\n")
		return false
	}

	if sizeof(Float64) != 8 {
		printf("error: sizeof(Float64) != 8\n")
		return false
	}


	if alignof(Float32) != 4 {
		printf("error: alignof(Float32) != 4\n")
		return false
	}

	if alignof(Float64) != 8 {
		printf("error: alignof(Float64) != 8\n")
		return false
	}


	printf("passed: testFloat\n")
	return true
}


func testFixed () -> Bool {
	if sizeof(Fixed32) != 4 {
		printf("error: sizeof(Fixed32) != 4\n")
		return false
	}

	if sizeof(Fixed64) != 8 {
		printf("error: sizeof(Fixed64) != 8\n")
		return false
	}


	if alignof(Fixed32) != 4 {
		printf("error: alignof(Fixed32) != 4\n")
		return false
	}

	if alignof(Fixed64) != 8 {
		printf("error: alignof(Fixed64) != 8\n")
		return false
	}


	printf("passed: testFixed\n")
	return true
}


func testArray () -> Bool {
	let arraySize = 10
	type ArrayItemType = Int32
	var array: [arraySize]ArrayItemType

	if lengthof(array) != arraySize {
		printf("error: lengthof(array) != arraySize\n")
		return false
	}

	if sizeof(array) != arraySize * sizeof(ArrayItemType) {
		printf("error: sizeof(array) != arraySize * sizeof(ArrayItemType)\n")
		return false
	}

	if alignof(array) != alignof(ArrayItemType) {
		printf("error: alignof(array) != alignof(ArrayItemType)\n")
		return false
	}

	printf("passed: testArray\n")
	return true
}


func testRecord () -> Bool {
	type Record = {x: Int32, y: Int32}
	var _record: Record

	if sizeof(_record) != 2 * sizeof(Int32) {
		printf("error: sizeof(record) != 2 * sizeof(Int32)\n")
		return false
	}

	if alignof(_record) != alignof(Record) {
		printf("error: alignof(_record) != alignof(Record)\n")
		return false
	}

	printf("passed: testRecord\n")
	return true
}


func testPointer () -> Bool {
	var pointer: *{}

	if unsafe Nat32 sizeof(pointer) != builtin.target.pointerWidth / 8 {
		printf("error: sizeof(pointer) != __target.pointerWidth / 8\n")
		return false
	}

	if alignof(pointer) != sizeof(pointer) {
		printf("error: alignof(pointer) != sizeof(pointer)\n")
		return false
	}

	printf("passed: testPointer\n")
	return true
}


public func main () -> Int {
	printf("test sizeof\n")

	var result = true
	result = testUnit() and result
	result = testBool() and result
	result = testWord() and result
	result = testInt() and result
	result = testNat() and result
	result = testChar() and result
	result = testFloat() and result
	result = testFixed() and result
	result = testArray() and result
	result = testRecord() and result
	result = testPointer() and result

	printf("test ")
	if not result {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}

