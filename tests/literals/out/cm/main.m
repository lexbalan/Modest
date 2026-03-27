include "ctypes64"
include "stdio"
include "stdlib"




// Проверки правильности работы арифметики для больших литералов
// Особенно актуальны для C бекенда, тк там 0xffffffff + 1 == 0 (!), etc.
func test1 () -> Bool {
	if 0xFFFFFFFF + 1 != 0x100000000 {
		printf("error: 0xffffffff + 1 != 0x100000000\n")
		return false
	}

	if 0xFFFFFFFF * 2 != 0x1FFFFFFFE {
		printf("error: 0xffffffff * 2 != 0x1fffffffe\n")
		return false
	}

	if 0xFFFFFFFF * 2 != 0xFFFFFFFF + 0xFFFFFFFF {
		printf("error: 0xffffffff * 2 != 0xffffffff + 0xffffffff\n")
		return false
	}

	if 0xFFFFFFFFFFFFFFFF + 1 != 0x10000000000000000 {
		printf("error: 0xffffffffffffffff + 1 != 0x10000000000000000\n")
		return false
	}

	let x32 = 0xFFFFFFFF
	if x32 + 1 != 0x100000000 {
		printf("error: x32 + 1 != 0x100000000\n")
		return false
	}

	let x64 = 0xFFFFFFFFFFFFFFFF
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
	var success: Bool = true

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

