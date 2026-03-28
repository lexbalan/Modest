
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
static int32_t testArray[23] = {-3, -5, 2, -11, 1, -1, 0, -2, 3, -4, 4, 11, -10, 9, 6, -7, -8, 5, 7, 10, 8, -6, -9};

static bool bubble_sort32_iter(int32_t array[], uint32_t len) {
	bool wasSwap = false;
	uint32_t i = 0U;
	while (i < len - 1U) {
		const int32_t left = array[i];
		const int32_t right = array[i + 1U];
		if (left > right) {
			array[i] = right;
			array[i + 1U] = left;
			wasSwap = true;
		}
		i = i + 1U;
	}
	return wasSwap;
}

static void bubble_sort32(int32_t array[], uint32_t len) {
	while (bubble_sort32_iter((int32_t *)array, len)) {
	}
}
static void print_array(int32_t array[], uint32_t len);

int32_t main(void) {
	printf("array before:\n");
	print_array((int32_t *)&testArray, LENGTHOF(testArray));
	printf("\n");
	bubble_sort32((int32_t *)&testArray, LENGTHOF(testArray));
	printf("array after:\n");
	print_array((int32_t *)&testArray, LENGTHOF(testArray));
	printf("\n");
	return 0;
}

static void print_array(int32_t array[], uint32_t len) {
	printf("\n");
	uint32_t i = 0U;
	while (i < len) {
		printf("array[%i] = %i\n", i, array[i]);
		i = i + 1U;
	}
}

