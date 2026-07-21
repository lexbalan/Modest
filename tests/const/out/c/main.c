
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
struct point {int32_t x; int32_t y;};
struct point3_d {int32_t x; int32_t y; int32_t z;};
typedef uint8_t Color;
#define COLOR_RED ((Color)0)
#define COLOR_GREEN ((Color)1)
#define COLOR_BLUE ((Color)2)
#define ANSWER 42

bool main_testGenericAdaptation(void) {
	int8_t asInt8 = ANSWER;
	int32_t asInt32 = ANSWER;
	uint64_t asNat64 = ANSWER;
	double asFloat64 = ANSWER;
	uint16_t asWord16 = ANSWER;
	if (asInt8 != 42) {
		printf("error: asInt8 != 42\n");
		return false;
	}
	if (asInt32 != 42) {
		printf("error: asInt32 != 42\n");
		return false;
	}
	if (asNat64 != (uint64_t)42) {
		printf("error: asNat64 != 42\n");
		return false;
	}
	if (asFloat64 != 42.0) {
		printf("error: asFloat64 != 42.0\n");
		return false;
	}
	if (asWord16 != (uint16_t)42) {
		printf("error: asWord16 != 42\n");
		return false;
	}
	printf("passed: generic adaptation test\n");
	return true;
}
#define ONE 1
#define TWO (ONE + 1)
#define COMBINED ((int8_t)TWO * (int8_t)TWO + ONE)
#define BIG 1000000
#define HEX_VAL 0x2A
#define NEGATED (-HEX_VAL)


bool main_testConstFolding(void) {
	if (TWO != 2) {
		printf("error: two != 2\n");
		return false;
	}
	if (COMBINED != 5) {
		printf("error: combined != 5\n");
		return false;
	}
	if (BIG != 1000000) {
		printf("error: big != 1000000\n");
		return false;
	}
	if (HEX_VAL != 42) {
		printf("error: hexVal != 42\n");
		return false;
	}
	if (NEGATED != -42) {
		printf("error: negated != -42\n");
		return false;
	}
	printf("passed: const folding test\n");
	return true;
}
#define TYPED_NAT ((uint32_t)100)
#define TYPED_INT ((int8_t)-100)
#define TYPED_FLOAT ((double)3.5)
#define TYPED_FROM_GENERIC ((int64_t)ONE)


bool main_testTypedConst(void) {
	if (TYPED_NAT != (uint32_t)100) {
		printf("error: typedNat != 100\n");
		return false;
	}
	if (TYPED_INT != -100) {
		printf("error: typedInt != -100\n");
		return false;
	}
	if (TYPED_FLOAT != 3.5) {
		printf("error: typedFloat != 3.5\n");
		return false;
	}
	if (TYPED_FROM_GENERIC != (int64_t)1) {
		printf("error: typedFromGeneric != 1\n");
		return false;
	}
	printf("passed: typed const test\n");
	return true;
}
#define GREETING "Hi\n"
#define CH "A"

bool main_testStringAndCharConst(void) {
	char fixed[3] = {'H', 'i', '\n'};
	if (LENGTHOF(fixed) != 3) {
		printf("error: lengthof(greeting) != 3\n");
		return false;
	}
	if (fixed[0] != 'H' || fixed[1] != 'i') {
		printf("error: greeting chars mismatch\n");
		return false;
	}
	char *g = GREETING;
	if (g[0] != 'H') {
		printf("error: greeting[0] != 'H'\n");
		return false;
	}
	char c = CH[0];
	if (c != 'A') {
		printf("error: ch != 'A'\n");
		return false;
	}
	printf("passed: string/char const test\n");
	return true;
}
#define NUMS {1, 2, 3}

bool main_testArrayConst(void) {
	int32_t same[3] = {1, 2, 3};
	if (__builtin_memcmp(&same, &(int32_t [3]){1, 2, 3}, sizeof(int32_t [3])) != 0) {
		printf("error: same != [1, 2, 3]\n");
		return false;
	}
	int32_t longer[5] = {1, 2, 3};
	if (longer[0] != 1 || longer[1] != 2 || longer[2] != 3) {
		printf("error: longer head mismatch\n");
		return false;
	}
	if (longer[3] != 0 || longer[4] != 0) {
		printf("error: longer tail not zero-filled\n");
		return false;
	}
	printf("passed: array const test\n");
	return true;
}
#define POINT2D {.x = 1, .y = 2}

bool main_testRecordConst(void) {
	struct point p = (struct point)POINT2D;
	if (p.x != 1 || p.y != 2) {
		printf("error: p.x/p.y mismatch\n");
		return false;
	}
	struct point3_d p3 = (struct point3_d){.x = 1, .y = 2,
		.z = 0};
	if (p3.x != 1 || p3.y != 2) {
		printf("error: p3.x/p3.y mismatch\n");
		return false;
	}
	if (p3.z != 0) {
		printf("error: p3.z not zero-filled\n");
		return false;
	}
	printf("passed: record const test\n");
	return true;
}
#define ZERO_ARR {0}
#define ZERO_POINT ((struct point){ \
	.x = 0, \
	.y = 0 \
})


bool main_testEmptyLiteralConst(void) {
	if (((const int32_t [4])ZERO_ARR)[0] != 0 || ((const int32_t [4])ZERO_ARR)[1] != 0 || ((const int32_t [4])ZERO_ARR)[2] != 0 || ((const int32_t [4])ZERO_ARR)[3] != 0) {
		printf("error: zeroArr not all zero\n");
		return false;
	}
	if (ZERO_POINT.x != 0 || ZERO_POINT.y != 0) {
		printf("error: zeroPoint not all zero\n");
		return false;
	}
	printf("passed: empty literal const test\n");
	return true;
}


bool main_testBrandedEnumConst(void) {
	if (COLOR_RED == COLOR_GREEN) {
		printf("error: colorRed == colorGreen\n");
		return false;
	}
	if (COLOR_GREEN == COLOR_BLUE) {
		printf("error: colorGreen == colorBlue\n");
		return false;
	}
	if (COLOR_RED != COLOR_RED) {
		printf("error: colorRed != colorRed\n");
		return false;
	}
	if ((uint8_t)COLOR_GREEN != 1) {
		printf("error: Nat8 colorGreen != 1\n");
		return false;
	}
	printf("passed: branded enum const test\n");
	return true;
}

bool main_testLocalConst(void) {
	#define localOne 1
	const int32_t localTwo = localOne + 1;
	if (localTwo != 2) {
		printf("error: localTwo != 2\n");
		return false;
	}
	double asFloat = localOne;
	if (asFloat != 1.0) {
		printf("error: asFloat != 1.0\n");
		return false;
	}
	printf("passed: local const test\n");
	return true;
	#undef localOne
}


int main(void) {
	printf("test const\n");
	bool result = true;
	result = main_testGenericAdaptation() && result;
	result = main_testConstFolding() && result;
	result = main_testTypedConst() && result;
	result = main_testStringAndCharConst() && result;
	result = main_testArrayConst() && result;
	result = main_testRecordConst() && result;
	result = main_testEmptyLiteralConst() && result;
	result = main_testBrandedEnumConst() && result;
	result = main_testLocalConst() && result;
	printf("test ");
	if (!result) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

