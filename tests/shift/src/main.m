// tests/shift/src/main.m

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"



func testShift32 () -> Bool {
	var x: Word32

	x = Word32 1 << 31
	if x != 0x80000000 {
		printf("error: Word32 1 << 31 != 0x80000000\n")
		return false
	}

	x = Word32 0x80000000 >> 31
	if x != 0x00000001 {
		printf("error: Word32 0x80000000 >> 31 != 0x00000001\n")
		return false
	}

	x = 1 << 31
	if x != 0x80000000 {
		printf("error: 1 << 31 != 0x80000000\n")
		return false
	}

	x = 0x80000000 >> 31
	if x != 0x00000001 {
		printf("error: 0x80000000 >> 31 != 0x00000001\n")
		return false
	}

	printf("passed: Shift32 test\n")
	return true
}


func testShift64 () -> Bool {
	var x: Word64

	x = Word64 1 << 63
	if x != 0x8000000000000000 {
		printf("error: Word64 1 << 63 != 0x8000000000000000\n")
		return false
	}

	x = Word64 0x8000000000000000 >> 63
	if x != 0x0000000000000001 {
		printf("error: Word64 0x8000000000000000 >> 63 != 0x0000000000000001\n")
		return false
	}

	x = Word64 1 << 63
	if x != 0x8000000000000000 {
		printf("error: 1 << 63 != 0x8000000000000000\n")
		return false
	}

	x = Word64 0x8000000000000000 >> 63
	if x != 0x0000000000000001 {
		printf("error: 0x8000000000000000 >> 63 != 0x0000000000000001\n")
		return false
	}

	printf("passed: Shift64 test\n")
	return true
}


func testShift128 () -> Bool {
	var x: Word128

	x = Word128 1 << 127
	if x != 0x80000000000000000000000000000000 {
		printf("error: Word128 1 << 127 != 0x80000000000000000000000000000000\n")
		return false
	}

	x = Word128 0x80000000000000000000000000000000 >> 127
	if x != 0x00000000000000000000000000000001 {
		printf("error: Word128 0x80000000000000000000000000000000 >> 127 != 0x00000000000000000000000000000001\n")
		return false
	}

	x = Word128 1 << 127
	if x != 0x80000000000000000000000000000000 {
		printf("error: 1 << 127 != 0x80000000000000000000000000000000\n")
		return false
	}

	x = Word128 0x80000000000000000000000000000000 >> 127
	if x != 0x00000000000000000000000000000001 {
		printf("error: 0x80000000000000000000000000000000 >> 127 != 0x00000000000000000000000000000001\n")
		return false
	}

	printf("passed: Shift128 test\n")
	return true
}



public func main () -> Int {
	printf("test shift\n")

	var result: Bool
	var success = true

	result = testShift32()
	success = success and result
	result = testShift64()
	success = success and result
	result = testShift128()
	success = success and result

	printf("test ")
	if not success {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}

