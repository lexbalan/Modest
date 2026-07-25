
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
struct point {int32_t x; int32_t y;};
static int32_t globalZeroInt;
static int32_t globalZeroArr[4];
static struct point globalZeroPoint;
static uint8_t r;
static uint8_t g;
static uint8_t b;
static int32_t globalCounter = 7;
static int32_t immutableGlobal = 42;

bool main_testGlobalZeroInit(void) {
	if (globalZeroInt != 0) {
		printf("error: globalZeroInt != 0\n");
		return false;
	}
	if (globalZeroArr[0] != 0 || globalZeroArr[3] != 0) {
		printf("error: globalZeroArr not all zero\n");
		return false;
	}
	if (globalZeroPoint.x != 0 || globalZeroPoint.y != 0) {
		printf("error: globalZeroPoint not all zero\n");
		return false;
	}
	if (r != 0 || g != 0 || b != 0) {
		printf("error: r/g/b not all zero\n");
		return false;
	}
	if (globalCounter != 7) {
		printf("error: globalCounter != 7\n");
		return false;
	}
	printf("passed: global zero-init test\n");
	return true;
}

bool main_testImmutableGlobal(void) {
	if (immutableGlobal != 42) {
		printf("error: immutableGlobal != 42\n");
		return false;
	}
	printf("passed: immutable global test\n");
	return true;
}

bool main_testTypedLocalVar(void) {
	int32_t a = 0;
	uint64_t n = 100;
	double f = 1.5;
	bool flag = true;
	char c = 'x';
	if (a != 0 || n != (uint64_t)100 || f != 1.5 || !flag || c != 'x') {
		printf("error: typed local var mismatch\n");
		return false;
	}
	printf("passed: typed local var test\n");
	return true;
}

bool main_testInferredLocalVar(void) {
	int32_t i = 10;
	double p = 3.14;
	bool flag = true;
	char *s = "hello";
	if (i != 10 || p != 3.14 || !flag) {
		printf("error: inferred local var mismatch\n");
		return false;
	}
	if (s[0] != 'h' || s[4] != 'o') {
		printf("error: inferred string var mismatch\n");
		return false;
	}
	printf("passed: inferred local var test\n");
	return true;
}

bool main_testMultiLocalDecl(void) {
	int32_t x1;
	int32_t x2;
	int32_t x3;
	x1 = 1;
	x2 = 2;
	x3 = 3;
	if (x1 != 1 || x2 != 2 || x3 != 3) {
		printf("error: multi local decl mismatch\n");
		return false;
	}
	printf("passed: multi local decl test\n");
	return true;
}

bool main_testExplicitZeroInit(void) {
	int32_t local;
	local = 5;
	if (local != 5) {
		printf("error: local != 5\n");
		return false;
	}
	int32_t zeroArr[4] = {0};
	if (zeroArr[0] != 0 || zeroArr[3] != 0) {
		printf("error: zeroArr not all zero\n");
		return false;
	}
	struct point zeroPoint = (struct point){0};
	if (zeroPoint.x != 0 || zeroPoint.y != 0) {
		printf("error: zeroPoint not all zero\n");
		return false;
	}
	printf("passed: explicit zero-init test\n");
	return true;
}

bool main_testLocalImmutable(void) {
	int32_t maxItems = 100;
	if (maxItems != 100) {
		printf("error: maxItems != 100\n");
		return false;
	}
	printf("passed: local immutable test\n");
	return true;
}

bool main_testVarArray(void) {
	int32_t arr[5] = {1, 2, 3, 4, 5};
	if (arr[0] != 1 || arr[4] != 5) {
		printf("error: arr element mismatch\n");
		return false;
	}
	int32_t mid[4 - 1];
	__builtin_memcpy(&mid, &arr[1], sizeof(int32_t [4 - 1]));
	if (__builtin_memcmp(&mid, &(int32_t [4 - 1]){2, 3, 4}, sizeof(int32_t [4 - 1])) != 0) {
		printf("error: mid != [2, 3, 4]\n");
		return false;
	}
	arr[0] = 9;
	if (arr[0] != 9) {
		printf("error: arr[0] != 9 after assignment\n");
		return false;
	}
	printf("passed: var array test\n");
	return true;
}

bool main_testVarRecord(void) {
	struct point p = (struct point){.x = 1, .y = 2};
	if (p.x != 1 || p.y != 2) {
		printf("error: p.x/p.y mismatch\n");
		return false;
	}
	p.x = 10;
	if (p.x != 10) {
		printf("error: p.x != 10 after assignment\n");
		return false;
	}
	struct point *pp = &p;
	pp->y = 20;
	if (p.y != 20) {
		printf("error: p.y != 20 after pointer field assignment\n");
		return false;
	}
	printf("passed: var record test\n");
	return true;
}

bool main_testVarPointer(void) {
	int32_t x = 1;
	int32_t *ptr = &x;
	if (*ptr != 1) {
		printf("error: *ptr != 1\n");
		return false;
	}
	*ptr = 100;
	if (x != 100) {
		printf("error: x != 100 after pointer write\n");
		return false;
	}
	printf("passed: var pointer test\n");
	return true;
}

bool main_testIncrementDecrement(void) {
	uint32_t i = 0;
	uint32_t j = 5;
	++i;
	++i;
	--j;
	if (i != 2 || j != 4) {
		printf("error: increment/decrement mismatch\n");
		return false;
	}
	printf("passed: increment/decrement test\n");
	return true;
}


int main(void) {
	printf("test var\n");
	bool result = true;
	result = main_testGlobalZeroInit() && result;
	result = main_testImmutableGlobal() && result;
	result = main_testTypedLocalVar() && result;
	result = main_testInferredLocalVar() && result;
	result = main_testMultiLocalDecl() && result;
	result = main_testExplicitZeroInit() && result;
	result = main_testLocalImmutable() && result;
	result = main_testVarArray() && result;
	result = main_testVarRecord() && result;
	result = main_testVarPointer() && result;
	result = main_testIncrementDecrement() && result;
	printf("test ");
	if (!result) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

