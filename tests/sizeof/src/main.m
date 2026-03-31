// tests/shift/src/main.m

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

	printf("builtin.compiler.version.major = %d\n", builtin.compiler.version.major)
	printf("builtin.compiler.version.minor = %d\n", builtin.compiler.version.minor)
	printf("builtin.target.name = %s\n", *Str8 builtin.target.name)
	printf("builtin.target.arch = %s\n", *Str8 builtin.target.arch)
	printf("builtin.target.os = %s\n", *Str8 builtin.target.os)
	printf("builtin.target.abi = %s\n", *Str8 builtin.target.abi)
	printf("builtin.target.endian = %s\n", *Str8 builtin.target.endian)

	if builtin.target.endian == builtin.endianBig {
		printf("it is a big-endian system\n")
	} else if builtin.target.endian == builtin.endianLittle {
		printf("it is a little-endian system\n")
	} else {
		printf("unknown endianess\n")
	}

	if builtin.target.arch == builtin.archArm {
		printf("it is an ARM (32) architecture\n")
	} else if builtin.target.arch == builtin.archAarch64 {
		printf("it is an ARM (64) architecture\n")
	} else if builtin.target.arch == builtin.archRiscv32 {
		printf("it is an RISC-V (32) architecture\n")
	} else if builtin.target.arch == builtin.archRiscv64 {
		printf("it is an RISC-V (64) architecture\n")
	} else if builtin.target.arch == builtin.archX86 {
		printf("it is an x86 (32) architecture\n")
	} else if builtin.target.arch == builtin.archX86_64 {
		printf("it is an x86 (64) architecture\n")
	} else {
		printf("it is an unknown architecture\n")
	}

	if builtin.target.os == builtin.osLinux {
		printf("it is a Linux operation system\n")
	} else if builtin.target.os == builtin.osWindows {
		printf("it is a Windows operation system\n")
	} else if builtin.target.os == builtin.osMacos {
		printf("it is a MacOS operation system\n")
	} else if builtin.target.os == builtin.osNoos {
		printf("There is no operation system\n")
	} else {
		printf("it is an Unknown operation system\n")
	}

	if builtin.target.abi == builtin.abiSysV {
		printf("it is a System V ABI\n")
	} else if builtin.target.abi == builtin.abiWin32 {
		printf("it is a Win32 ABI\n")
	} else if builtin.target.abi == builtin.abiWin64 {
		printf("it is a Win64 ABI\n")
	} else if builtin.target.abi == builtin.abiEabi {
		printf("it is a EABI\n")
	} else {
		printf("it is an Unknown ABI\n")
	}

	var result: Bool
	var success = true

	result = testUnit()
	success = success and result
	result = testBool()
	success = success and result
	result = testWord()
	success = success and result
	result = testInt()
	success = success and result
	result = testNat()
	success = success and result
	result = testChar()
	success = success and result
	result = testFloat()
	success = success and result
	result = testFixed()
	success = success and result
	result = testArray()
	success = success and result
	result = testRecord()
	success = success and result
	result = testPointer()
	success = success and result

	printf("test ")
	if not success {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}

