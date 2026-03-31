
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
#if !defined(__STR_UNICODE__)
#define __STR_UNICODE__
typedef uint8_t char8_t;
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#define __STR8(x) x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x) __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#endif

static bool testUnit(void) {
	if ((size_t)0 != 0ULL) {
		printf("error: sizeof(Unit) != 0\n");
		return false;
	}
	if ((size_t)1 != 1ULL) {
		printf("error: alignof(Unit) != 1\n");
		return false;
	}
	printf("passed: testUnit\n");
	return true;
}

static bool testBool(void) {
	if (sizeof(bool) != 1ULL) {
		printf("error: sizeof(Bool) != 1\n");
		return false;
	}
	if (__alignof(bool) != 1ULL) {
		printf("error: alignof(Bool) != 1\n");
		return false;
	}
	printf("passed: testBool\n");
	return true;
}

static bool testWord(void) {
	if (sizeof(uint8_t) != 1ULL) {
		printf("error: sizeof(Word8) != 1\n");
		return false;
	}
	if (sizeof(uint16_t) != 2ULL) {
		printf("error: sizeof(Word16) != 2\n");
		return false;
	}
	if (sizeof(uint32_t) != 4ULL) {
		printf("error: sizeof(Word32) != 4\n");
		return false;
	}
	if (sizeof(uint64_t) != 8ULL) {
		printf("error: sizeof(Word64) != 8\n");
		return false;
	}
	if (__alignof(uint8_t) != 1ULL) {
		printf("error: alignof(Word8) != 1\n");
		return false;
	}
	if (__alignof(uint16_t) != 2ULL) {
		printf("error: alignof(Word16) != 2\n");
		return false;
	}
	if (__alignof(uint32_t) != 4ULL) {
		printf("error: alignof(Word32) != 4\n");
		return false;
	}
	if (__alignof(uint64_t) != 8ULL) {
		printf("error: alignof(Word64) != 8\n");
		return false;
	}
	printf("passed: testWord\n");
	return true;
}

static bool testInt(void) {
	if (sizeof(int8_t) != 1ULL) {
		printf("error: sizeof(Int8) != 1\n");
		return false;
	}
	if (sizeof(int16_t) != 2ULL) {
		printf("error: sizeof(Int16) != 2\n");
		return false;
	}
	if (sizeof(int32_t) != 4ULL) {
		printf("error: sizeof(Int32) != 4\n");
		return false;
	}
	if (sizeof(int64_t) != 8ULL) {
		printf("error: sizeof(Int64) != 8\n");
		return false;
	}
	if (__alignof(int8_t) != 1ULL) {
		printf("error: alignof(Int8) != 1\n");
		return false;
	}
	if (__alignof(int16_t) != 2ULL) {
		printf("error: alignof(Int16) != 2\n");
		return false;
	}
	if (__alignof(int32_t) != 4ULL) {
		printf("error: alignof(Int32) != 4\n");
		return false;
	}
	if (__alignof(int64_t) != 8ULL) {
		printf("error: alignof(Int64) != 8\n");
		return false;
	}
	printf("passed: testInt\n");
	return true;
}

static bool testNat(void) {
	if (sizeof(uint8_t) != 1ULL) {
		printf("error: sizeof(Nat8) != 1\n");
		return false;
	}
	if (sizeof(uint16_t) != 2ULL) {
		printf("error: sizeof(Nat16) != 2\n");
		return false;
	}
	if (sizeof(uint32_t) != 4ULL) {
		printf("error: sizeof(Nat32) != 4\n");
		return false;
	}
	if (sizeof(uint64_t) != 8ULL) {
		printf("error: sizeof(Nat64) != 8\n");
		return false;
	}
	if (__alignof(uint8_t) != 1ULL) {
		printf("error: alignof(Nat8) != 1\n");
		return false;
	}
	if (__alignof(uint16_t) != 2ULL) {
		printf("error: alignof(Nat16) != 2\n");
		return false;
	}
	if (__alignof(uint32_t) != 4ULL) {
		printf("error: alignof(Nat32) != 4\n");
		return false;
	}
	if (__alignof(uint64_t) != 8ULL) {
		printf("error: alignof(Nat64) != 8\n");
		return false;
	}
	printf("passed: testNat\n");
	return true;
}

static bool testChar(void) {
	if (sizeof(char) != 1ULL) {
		printf("error: sizeof(Char8) != 1\n");
		return false;
	}
	if (sizeof(char16_t) != 2ULL) {
		printf("error: sizeof(Char16) != 2\n");
		return false;
	}
	if (sizeof(char32_t) != 4ULL) {
		printf("error: sizeof(Char32) != 4\n");
		return false;
	}
	if (__alignof(char) != 1ULL) {
		printf("error: alignof(Char8) != 1\n");
		return false;
	}
	if (__alignof(char16_t) != 2ULL) {
		printf("error: alignof(Char16) != 2\n");
		return false;
	}
	if (__alignof(char32_t) != 4ULL) {
		printf("error: alignof(Char32) != 4\n");
		return false;
	}
	printf("passed: testChar\n");
	return true;
}

static bool testFloat(void) {
	if (sizeof(float) != 4ULL) {
		printf("error: sizeof(Float32) != 4\n");
		return false;
	}
	if (sizeof(double) != 8ULL) {
		printf("error: sizeof(Float64) != 8\n");
		return false;
	}
	if (__alignof(float) != 4ULL) {
		printf("error: alignof(Float32) != 4\n");
		return false;
	}
	if (__alignof(double) != 8ULL) {
		printf("error: alignof(Float64) != 8\n");
		return false;
	}
	printf("passed: testFloat\n");
	return true;
}

static bool testFixed(void) {
	if (sizeof(int32_t) != 4ULL) {
		printf("error: sizeof(Fixed32) != 4\n");
		return false;
	}
	if (sizeof(int64_t) != 8ULL) {
		printf("error: sizeof(Fixed64) != 8\n");
		return false;
	}
	if (__alignof(int32_t) != 4ULL) {
		printf("error: alignof(Fixed32) != 4\n");
		return false;
	}
	if (__alignof(int64_t) != 8ULL) {
		printf("error: alignof(Fixed64) != 8\n");
		return false;
	}
	printf("passed: testFixed\n");
	return true;
}

static bool testArray(void) {
	#define arraySize 10
	typedef int32_t ArrayItemType;
	ArrayItemType array[arraySize];
	if (LENGTHOF(array) != arraySize) {
		printf("error: lengthof(array) != arraySize\n");
		return false;
	}
	if (sizeof array != arraySize * sizeof(ArrayItemType)) {
		printf("error: sizeof(array) != arraySize * sizeof(ArrayItemType)\n");
		return false;
	}
	if (__alignof(__typeof__(array)) != __alignof(ArrayItemType)) {
		printf("error: alignof(array) != alignof(ArrayItemType)\n");
		return false;
	}
	printf("passed: testArray\n");
	return true;
	#undef arraySize
}

static bool testRecord(void) {
	struct record {int32_t x; int32_t y;};
	struct record _record;
	if (sizeof _record != 2ULL * sizeof(int32_t)) {
		printf("error: sizeof(record) != 2 * sizeof(Int32)\n");
		return false;
	}
	if (__alignof(__typeof__(_record)) != __alignof(struct record)) {
		printf("error: alignof(_record) != alignof(Record)\n");
		return false;
	}
	printf("passed: testRecord\n");
	return true;
}

static bool testPointer(void) {
	struct {uint8_t __placeholder;} *pointer;
	if ((uint32_t)sizeof pointer != 64 / 8) {
		printf("error: sizeof(pointer) != __target.pointerWidth / 8\n");
		return false;
	}
	if (__alignof(__typeof__(pointer)) != sizeof pointer) {
		printf("error: alignof(pointer) != sizeof(pointer)\n");
		return false;
	}
	printf("passed: testPointer\n");
	return true;
}

int main(void) {
	printf("test sizeof\n");
	printf("builtin.compiler.version.major = %d\n", 0U);
	printf("builtin.compiler.version.minor = %d\n", 7U);
	printf("builtin.target.name = %s\n", "Default");
	printf("builtin.target.arch = %s\n", "aarch64");
	printf("builtin.target.os = %s\n", "darwin");
	printf("builtin.target.abi = %s\n", "sysv");
	printf("builtin.target.endian = %s\n", "little-endian");
	if (__builtin_strcmp((char *const )&"little-endian", (char *const )&"big-endian") == 0) {
		printf("it is a big-endian system\n");
	} else if (__builtin_strcmp((char *const )&"little-endian", (char *const )&"little-endian") == 0) {
		printf("it is a little-endian system\n");
	} else {
		printf("unknown endianess\n");
	}
	if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"arm") == 0) {
		printf("it is an ARM (32) architecture\n");
	} else if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"aarch64") == 0) {
		printf("it is an ARM (64) architecture\n");
	} else if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"riscv32") == 0) {
		printf("it is an RISC-V (32) architecture\n");
	} else if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"riscv64") == 0) {
		printf("it is an RISC-V (64) architecture\n");
	} else if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"x86") == 0) {
		printf("it is an x86 (32) architecture\n");
	} else if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"x86_64") == 0) {
		printf("it is an x86 (64) architecture\n");
	} else {
		printf("it is an unknown architecture\n");
	}
	if (__builtin_strcmp((char *const )&"darwin", (char *const )&"linux") == 0) {
		printf("it is a Linux operation system\n");
	} else if (__builtin_strcmp((char *const )&"darwin", (char *const )&"windows") == 0) {
		printf("it is a Windows operation system\n");
	} else if (__builtin_strcmp((char *const )&"darwin", (char *const )&"darwin") == 0) {
		printf("it is a MacOS operation system\n");
	} else if (__builtin_strcmp((char *const )&"darwin", (char *const )&"noos") == 0) {
		printf("There is no operation system\n");
	} else {
		printf("it is an Unknown operation system\n");
	}
	if (__builtin_strcmp((char *const )&"sysv", (char *const )&"sysv") == 0) {
		printf("it is a System V ABI\n");
	} else if (__builtin_strcmp((char *const )&"sysv", (char *const )&"win32") == 0) {
		printf("it is a Win32 ABI\n");
	} else if (__builtin_strcmp((char *const )&"sysv", (char *const )&"win64") == 0) {
		printf("it is a Win64 ABI\n");
	} else if (__builtin_strcmp((char *const )&"sysv", (char *const )&"eabi") == 0) {
		printf("it is a EABI\n");
	} else {
		printf("it is an Unknown ABI\n");
	}
	bool result;
	bool success = true;
	result = testUnit();
	success = success && result;
	result = testBool();
	success = success && result;
	result = testWord();
	success = success && result;
	result = testInt();
	success = success && result;
	result = testNat();
	success = success && result;
	result = testChar();
	success = success && result;
	result = testFloat();
	success = success && result;
	result = testFixed();
	success = success && result;
	result = testArray();
	success = success && result;
	result = testRecord();
	success = success && result;
	result = testPointer();
	success = success && result;
	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

