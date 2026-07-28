
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif

static void array4intInc(int32_t *_a, int32_t *__out) {
	int32_t a[4];
	__builtin_memcpy(a, _a, sizeof(int32_t [4]));
	__builtin_memcpy(__out, &(int32_t [4]){a[0] + 1, a[1] + 1, a[2] + 1, a[3] + 1}, sizeof(int32_t [4]));
}

static int32_t sum4(int32_t *_a) {
	int32_t a[4];
	__builtin_memcpy(a, _a, sizeof(int32_t [4]));
	return a[0] + a[1] + a[2] + a[3];
}
//
// 1. read a slice, literal bounds
//

static bool testReadLiteralBounds(void) {
	int32_t a[5] = {10, 20, 30, 40, 50};
	int32_t s[4 - 1];
	__builtin_memcpy(&s, &a[1], sizeof(const int32_t [4 - 1]));
	const int32_t expected[3] = {20, 30, 40};
	if (LENGTHOF(s) != 3) {
		printf("FAIL testReadLiteralBounds: wrong length\n");
		return false;
	}
	if (__builtin_memcmp(&s, &expected, sizeof(const int32_t [4 - 1])) != 0) {
		printf("FAIL testReadLiteralBounds: wrong contents\n");
		return false;
	}
	printf("passed: read slice, literal bounds\n");
	return true;
}
//
// 2. read a slice, bounds come from `let` (not compile-time literals)
//

static bool testReadRuntimeBounds(void) {
	int32_t a[5] = {10, 20, 30, 40, 50};
	#define i 1
	#define j 4
	int32_t s[j - i];
	__builtin_memcpy(&s, &a[i], sizeof(const int32_t [j - i]));
	const int32_t expected[3] = {20, 30, 40};
	if (LENGTHOF(s) != 3) {
		printf("FAIL testReadRuntimeBounds: wrong length\n");
		return false;
	}
	if (__builtin_memcmp(&s, &expected, sizeof(const int32_t [j - i])) != 0) {
		printf("FAIL testReadRuntimeBounds: wrong contents\n");
		return false;
	}
	printf("passed: read slice, runtime bounds\n");
	return true;
	#undef i
	#undef j
}
//
// 3. read a slice through a pointer to array (auto-deref)
//

static bool testReadViaPointer(void) {
	int32_t a[5] = {10, 20, 30, 40, 50};
	int32_t *const pa = a;
	int32_t s[4 - 1];
	__builtin_memcpy(&s, &pa[1], sizeof(const int32_t [4 - 1]));
	const int32_t expected[3] = {20, 30, 40};
	if (LENGTHOF(s) != 3) {
		printf("FAIL testReadViaPointer: wrong length\n");
		return false;
	}
	if (__builtin_memcmp(&s, &expected, sizeof(const int32_t [4 - 1])) != 0) {
		printf("FAIL testReadViaPointer: wrong contents\n");
		return false;
	}
	printf("passed: read slice via pointer to array\n");
	return true;
}
//
// 4. empty slice: from == to
//

static bool testEmptySlice(void) {
	int32_t a[5] = {10, 20, 30, 40, 50};
	int32_t s[2 - 2];
	__builtin_memcpy(&s, &a[2], sizeof(const int32_t [2 - 2]));
	if (LENGTHOF(s) != 0) {
		printf("FAIL testEmptySlice: expected length 0\n");
		return false;
	}
	printf("passed: empty slice\n");
	return true;
}
//
// 5. full-range slice
//

static bool testFullRangeSlice(void) {
	int32_t a[5] = {10, 20, 30, 40, 50};
	int32_t s[LENGTHOF(a) - 0];
	__builtin_memcpy(&s, &a[0], sizeof(const int32_t [LENGTHOF(a) - 0]));
	if (LENGTHOF(s) != LENGTHOF(a)) {
		printf("FAIL testFullRangeSlice: wrong length\n");
		return false;
	}
	if (__builtin_memcmp(&s, &a, sizeof(const int32_t [LENGTHOF(a) - 0])) != 0) {
		printf("FAIL testFullRangeSlice: wrong contents\n");
		return false;
	}
	printf("passed: full range slice\n");
	return true;
}
//
// 6. slice of an unsized array
//

static bool testUnsizedArraySlice(void) {
	int32_t a[5] = {10, 20, 30, 40, 50};
	int32_t s[4 - 1];
	__builtin_memcpy(&s, &a[1], sizeof(const int32_t [4 - 1]));
	const int32_t expected[3] = {20, 30, 40};
	if (LENGTHOF(s) != 3) {
		printf("FAIL testUnsizedArraySlice: wrong length\n");
		return false;
	}
	if (__builtin_memcmp(&s, &expected, sizeof(const int32_t [4 - 1])) != 0) {
		printf("FAIL testUnsizedArraySlice: wrong contents\n");
		return false;
	}
	printf("passed: slice of unsized array\n");
	return true;
}
//
// 7. slice as a function argument (pass-by-value)
//

static bool testSliceAsFuncArg(void) {
	int32_t a[8] = {1, 2, 3, 4, 5, 6, 7, 8};
	if (sum4(&a[0]) != 10) {
		printf("FAIL testSliceAsFuncArg: wrong sum for first half\n");
		return false;
	}
	if (sum4(&a[4]) != 26) {
		printf("FAIL testSliceAsFuncArg: wrong sum for second half\n");
		return false;
	}
	printf("passed: slice as function argument\n");
	return true;
}
//
// 8. slice assignment from a function's return value
//

static bool testSliceAssignFromCall(void) {
	int32_t a[8] = {0, 1, 2, 3, 4, 5, 6, 7};
	array4intInc(&a[0], &a[0]);
	array4intInc(&a[4], &a[4]);
	const int32_t expected[8] = {1, 2, 3, 4, 5, 6, 7, 8};
	if (__builtin_memcmp(&a, &expected, sizeof(int32_t [8])) != 0) {
		printf("FAIL testSliceAssignFromCall: wrong contents\n");
		return false;
	}
	printf("passed: slice assignment from function return\n");
	return true;
}
//
// 9. slice assignment from an array literal, literal bounds
//    docs/lang/value/slice.md: `a[0:2] = [2]Int32 [9, 9]`
//    known bug: docs/BUGS.md #3
//

static bool testSliceAssignFromLiteral(void) {
	int32_t a[5] = {0, 0, 0, 0, 0};
	__builtin_memcpy(&a[1], &(int32_t [3]){7, 8, 9}, sizeof(int32_t [4 - 1]));
	const int32_t expected[5] = {0, 7, 8, 9, 0};
	if (__builtin_memcmp(&a, &expected, sizeof(int32_t [5])) != 0) {
		printf("FAIL testSliceAssignFromLiteral: wrong contents (see docs/BUGS.md #3)\n");
		return false;
	}
	printf("passed: slice assignment from array literal\n");
	return true;
}
//
// 10. same as above, but bounds come from `let` variables, not literals
//

static bool testSliceAssignFromLiteralRuntimeBounds(void) {
	int32_t a[5] = {0, 0, 0, 0, 0};
	#define i 1
	#define j 4
	__builtin_memcpy(&a[i], &(int32_t [3]){7, 8, 9}, sizeof(int32_t [j - i]));
	const int32_t expected[5] = {0, 7, 8, 9, 0};
	if (__builtin_memcmp(&a, &expected, sizeof(int32_t [5])) != 0) {
		printf("FAIL testSliceAssignFromLiteralRuntimeBounds: wrong contents (see docs/BUGS.md #3)\n");
		return false;
	}
	printf("passed: slice assignment from array literal, runtime bounds\n");
	return true;
	#undef i
	#undef j
}
//
// 11. slice assignment with a wider element type
//     (checks whether the byte-count bug in #9/#10 scales with element size)
//

static bool testSliceAssignWiderElementType(void) {
	uint64_t a[4] = {0, 0, 0, 0};
	__builtin_memcpy(&a[1], &(uint64_t [2]){111, 222}, sizeof(uint64_t [3 - 1]));
	const uint64_t expected[4] = {0, 111, 222, 0};
	if (__builtin_memcmp(&a, &expected, sizeof(uint64_t [4])) != 0) {
		printf("FAIL testSliceAssignWiderElementType: wrong contents (see docs/BUGS.md #3)\n");
		return false;
	}
	printf("passed: slice assignment, wider element type\n");
	return true;
}


int32_t main(void) {
	printf("test slice\n");
	bool result = true;
	result = testReadLiteralBounds() && result;
	result = testReadRuntimeBounds() && result;
	result = testReadViaPointer() && result;
	result = testEmptySlice() && result;
	result = testFullRangeSlice() && result;
	result = testUnsizedArraySlice() && result;
	result = testSliceAsFuncArg() && result;
	result = testSliceAssignFromCall() && result;
	result = testSliceAssignFromLiteral() && result;
	result = testSliceAssignFromLiteralRuntimeBounds() && result;
	result = testSliceAssignWiderElementType() && result;
	printf("test ");
	if (!result) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

