
#include "basic.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
struct point {
	int32_t x;
	int32_t y;
};

static bool testVariable(void) {
	int32_t x = 1;
	x = 10;
	if (x != 10) {
		printf("x = %d, expected 10\n", x);
		return false;
	}
	x = x + 5;
	if (x != 15) {
		printf("x = %d, expected 15\n", x);
		return false;
	}
	x = 42;
	if (x != 42) {
		printf("x = %d, expected 42\n", x);
		return false;
	}
	printf("passed: variable assign\n");
	return true;
}

static bool testArrayElement(void) {
	int32_t arr[5] = {1, 2, 3, 4, 5};
	arr[0] = 100;
	if (arr[0] != 100) {
		printf("arr[0] = %d, expected 100\n", arr[0]);
		return false;
	}
	int32_t i = 4;
	arr[i] = 500;
	if (arr[4] != 500) {
		printf("arr[4] = %d, expected 500\n", arr[4]);
		return false;
	}
	if (arr[2] != 3) {
		printf("arr[2] = %d, expected 3\n", arr[2]);
		return false;
	}
	printf("passed: array assign\n");
	return true;
}

static bool testSlice(void) {
	int32_t arr[5] = {1, 2, 3, 4, 5};
	__builtin_memcpy(&arr[1], &(int32_t [3]){7, 8, 9}, sizeof(int32_t [4 - 1]));
	if (arr[0] != 1) {
		printf("arr[0] = %d, expected 1 (before the slice)\n", arr[0]);
		return false;
	}
	if (arr[1] != 7 || arr[2] != 8 || arr[3] != 9) {
		printf("arr[1:4] = [%d, %d, %d], expected [7, 8, 9]\n", arr[1], arr[2], arr[3]);
		return false;
	}
	if (arr[4] != 5) {
		printf("arr[4] = %d, expected 5 (after the slice)\n", arr[4]);
		return false;
	}
	printf("passed: slice assign\n");
	return true;
}

static bool testField(void) {
	struct point pt = (struct point){.x = 1, .y = 2};
	pt.x = 30;
	if (pt.x != 30) {
		printf("pt.x = %d, expected 30\n", pt.x);
		return false;
	}
	struct point *const p = &pt;
	p->y = 40;
	if (pt.y != 40) {
		printf("pt.y = %d, expected 40 after write through pointer\n", pt.y);
		return false;
	}
	printf("passed: field assign\n");
	return true;
}

static bool testDeref(void) {
	int32_t n = 1;
	int32_t *const p = &n;
	*p = 99;
	if (n != 99) {
		printf("n = %d, expected 99 after *p = 99\n", n);
		return false;
	}
	printf("passed: deref assign\n");
	return true;
}

static bool testIncrement(void) {
	int32_t i = 5;
	++i;
	if (i != 6) {
		printf("i = %d, expected 6 after ++i\n", i);
		return false;
	}
	--i;
	--i;
	if (i != 4) {
		printf("i = %d, expected 4 after two --i\n", i);
		return false;
	}
	printf("passed: increment\n");
	return true;
}


int main(void) {
	bool result = true;
	result = testVariable() && result;
	result = testArrayElement() && result;
	result = testSlice() && result;
	result = testField() && result;
	result = testDeref() && result;
	result = testIncrement() && result;
	if (!result) {
		printf("failed: assign\n");
		return EXIT_FAILURE;
	}
	printf("passed: assign\n");
	return EXIT_SUCCESS;
}

