
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
	bool result = true;
	result = testUnit() && result;
	result = testBool() && result;
	result = testWord() && result;
	result = testInt() && result;
	result = testNat() && result;
	result = testChar() && result;
	result = testFloat() && result;
	result = testFixed() && result;
	result = testArray() && result;
	result = testRecord() && result;
	result = testPointer() && result;
	printf("test ");
	if (!result) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

