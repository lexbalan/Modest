
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
struct rect {struct point topLeft; struct point bottomRight;};
struct poly3 {struct point verts[3]; int32_t count;};
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
	struct point3_d p3 = (struct point3_d){.x = 1, .y = 2};
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
#define RECT_CONST {.topLeft = {.x = 0, .y = 0}, .bottomRight = {.x = 10, .y = 20}}
#define RECT_PARTIAL {.topLeft = {.x = 1, .y = 1}}
#define RECT_ZERO ((struct rect){0})


bool main_testNestedRecordConst(void) {
	struct rect r = (struct rect)RECT_CONST;
	if (r.topLeft.x != 0 || r.topLeft.y != 0 || r.bottomRight.x != 10 || r.bottomRight.y != 20) {
		printf("error: rectConst mismatch\n");
		return false;
	}
	struct rect rp = (struct rect){.topLeft = {.x = 1, .y = 1}};
	if (rp.topLeft.x != 1 || rp.topLeft.y != 1) {
		printf("error: rectPartial.topLeft mismatch\n");
		return false;
	}
	if (rp.bottomRight.x != 0 || rp.bottomRight.y != 0) {
		printf("error: rectPartial.bottomRight not zero-filled\n");
		return false;
	}
	if (RECT_ZERO.topLeft.x != 0 || RECT_ZERO.topLeft.y != 0 || RECT_ZERO.bottomRight.x != 0 || RECT_ZERO.bottomRight.y != 0) {
		printf("error: rectZero not all zero\n");
		return false;
	}
	printf("passed: nested record const test\n");
	return true;
}
#define MATRIX {{1, 2, 3}, {4, 5, 6}}

bool main_testNestedArrayConst(void) {
	int32_t m[2][3] = {{1, 2, 3}, {4, 5, 6}};
	if (m[0][0] != 1 || m[0][2] != 3 || m[1][0] != 4 || m[1][2] != 6) {
		printf("error: matrix mismatch\n");
		return false;
	}
	int32_t wider[3][3] = {{1, 2, 3}, {4, 5, 6}};
	if (__builtin_memcmp(&wider[0], &(int32_t [3]){1, 2, 3}, sizeof(int32_t [3])) != 0 || __builtin_memcmp(&wider[1], &(int32_t [3]){4, 5, 6}, sizeof(int32_t [3])) != 0) {
		printf("error: wider head mismatch\n");
		return false;
	}
	if (__builtin_memcmp(&wider[2], &(int32_t [3]){0, 0, 0}, sizeof(int32_t [3])) != 0) {
		printf("error: wider extra row not zero-filled\n");
		return false;
	}
	if (__builtin_memcmp(&wider, &(int32_t [3][3]){{1, 2, 3}, {4, 5, 6}, {0, 0, 0}}, sizeof(int32_t [3][3])) != 0) {
		printf("error: wider != [[1,2,3],[4,5,6],[0,0,0]]\n");
		return false;
	}
	int32_t empty[2][3] = {0};
	int32_t mz[2][3] = {0};
	if (mz[0][0] != 0 || mz[0][1] != 0 || mz[0][2] != 0) {
		printf("error: mz row 0 not all zero\n");
		return false;
	}
	if (mz[1][0] != 0 || mz[1][1] != 0 || mz[1][2] != 0) {
		printf("error: mz row 1 not all zero\n");
		return false;
	}
	if (__builtin_memcmp(&mz, &(int32_t [2][3]){{0, 0, 0}, {0, 0, 0}}, sizeof(int32_t [2][3])) != 0) {
		printf("error: mz != [[0,0,0],[0,0,0]]\n");
		return false;
	}
	if (__builtin_memcmp(&mz, &empty, sizeof(int32_t [2][3])) != 0) {
		printf("error: mz != empty\n");
		return false;
	}
	printf("passed: nested array const test\n");
	return true;
}
#define POINTS {{.x = 1, .y = 1}, {.x = 2, .y = 2}, {.x = 3, .y = 3}}

bool main_testArrayOfRecordsConst(void) {
	struct point arr[3] = {{.x = 1, .y = 1}, {.x = 2, .y = 2}, {.x = 3, .y = 3}};
	if (arr[0].x != 1 || arr[0].y != 1 || arr[2].x != 3 || arr[2].y != 3) {
		printf("error: points mismatch\n");
		return false;
	}
	struct point longer[5] = {{.x = 1, .y = 1}, {.x = 2, .y = 2}, {.x = 3, .y = 3}};
	if (longer[2].x != 3 || longer[2].y != 3) {
		printf("error: longer head mismatch\n");
		return false;
	}
	if (longer[3].x != 0 || longer[3].y != 0 || longer[4].x != 0 || longer[4].y != 0) {
		printf("error: longer tail records not zero-filled\n");
		return false;
	}
	printf("passed: array of records const test\n");
	return true;
}
#define TRIANGLE {.verts = {{.x = 0, .y = 0}, {.x = 1, .y = 0}, {.x = 0, .y = 1}}, .count = 3}
#define POLY_PARTIAL {.count = 1}

bool main_testRecordWithArrayFieldConst(void) {
	struct poly3 poly = (struct poly3)TRIANGLE;
	if (poly.count != 3) {
		printf("error: triangle.count mismatch\n");
		return false;
	}
	if (poly.verts[0].x != 0 || poly.verts[1].x != 1 || poly.verts[2].y != 1) {
		printf("error: triangle.verts mismatch\n");
		return false;
	}
	struct poly3 polyP = (struct poly3){.count = 1};
	if (polyP.count != 1) {
		printf("error: polyPartial.count mismatch\n");
		return false;
	}
	if (polyP.verts[0].x != 0 || polyP.verts[1].y != 0 || polyP.verts[2].x != 0) {
		printf("error: polyPartial.verts not zero-filled\n");
		return false;
	}
	printf("passed: record with array field const test\n");
	return true;
}
#define ZERO_ARR {0}
#define ZERO_POINT ((struct point){0})
#define ZERO_POINTS {0}
#define ZERO_MATRIX {0}


bool main_testEmptyLiteralConst(void) {
	if (((const int32_t [4])ZERO_ARR)[0] != 0 || ((const int32_t [4])ZERO_ARR)[1] != 0 || ((const int32_t [4])ZERO_ARR)[2] != 0 || ((const int32_t [4])ZERO_ARR)[3] != 0) {
		printf("error: zeroArr not all zero\n");
		return false;
	}
	if (ZERO_POINT.x != 0 || ZERO_POINT.y != 0) {
		printf("error: zeroPoint not all zero\n");
		return false;
	}
	if (((int32_t [2][3])ZERO_MATRIX)[0][0] != 0 || ((int32_t [2][3])ZERO_MATRIX)[0][2] != 0 || ((int32_t [2][3])ZERO_MATRIX)[1][0] != 0 || ((int32_t [2][3])ZERO_MATRIX)[1][2] != 0) {
		printf("error: zeroMatrix not all zero\n");
		return false;
	}
	if (((const struct point [3])ZERO_POINTS)[0].x != 0 || ((const struct point [3])ZERO_POINTS)[0].y != 0 || ((const struct point [3])ZERO_POINTS)[1].x != 0 || ((const struct point [3])ZERO_POINTS)[1].y != 0 || ((const struct point [3])ZERO_POINTS)[2].x != 0 || ((const struct point [3])ZERO_POINTS)[2].y != 0) {
		printf("error: zeroPoints not all zero\n");
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
	result = main_testNestedRecordConst() && result;
	result = main_testNestedArrayConst() && result;
	result = main_testArrayOfRecordsConst() && result;
	result = main_testRecordWithArrayFieldConst() && result;
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

