// tests/shift/src/main.m

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"



func test1 () -> Bool {
	if 0xffffffff + 1 != 0x100000000 {
		printf("error: 0xffffffff + 1 != 0x100000000\n")
		return false
	}

	let a = 0xffffffff
	if a + 1 != 0x100000000 {
		printf("error: a + 1 != 0x100000000\n")
		return false
	}

	printf("passed: test1 test\n")
	return true
}


public func main () -> Int {
	printf("test shift\n")

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

