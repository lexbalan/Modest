// tests/shift/src/main.m

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"



func test1 () -> Bool {
	if 0xffffffff + 1 != 0x100000000 {
		printf("error: 0xffffffff + 1 != 0x100000000\n")
		return false
	}

	if 0xffffffffffffffff + 1 != 0x10000000000000000 {
		printf("error: 0xffffffffffffffff + 1 != 0x10000000000000000\n")
		return false
	}

	let x32 = 0xffffffff
	if x32 + 1 != 0x100000000 {
		printf("error: x32 + 1 != 0x100000000\n")
		return false
	}

	let x64 = 0xffffffffffffffff
	if x64 + 1 != 0x10000000000000000 {
		printf("error: x64 + 1 != 0x10000000000000000\n")
		return false
	}

	printf("passed: test1\n")
	return true
}


public func main () -> Int {
	printf("test literals\n")

	var result: Bool
	var success = true

	result = test1()
	success = success and result

	printf("test ")
	if not success {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}

