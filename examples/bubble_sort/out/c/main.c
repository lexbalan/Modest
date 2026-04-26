
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
static int32_t main_testArray[23] = {-3, -5, 2, -11, 1, -1, 0, -2, 3, -4, 4, 11, -10, 9, 6, -7, -8, 5, 7, 10, 8, -6, -9};

static bool main_bubble_sort32_iter(int32_t array[], uint32_t len) {
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

static void main_bubble_sort32(int32_t array[], uint32_t len) {
	while (main_bubble_sort32_iter((int32_t *)array, len)) {
	}
}
static void main_print_array(int32_t array[], uint32_t len);

int32_t main(void) {
	printf("array before:\n");
	main_print_array((int32_t *)&main_testArray, LENGTHOF(main_testArray));
	printf("\n");
	main_bubble_sort32((int32_t *)&main_testArray, LENGTHOF(main_testArray));
	printf("array after:\n");
	main_print_array((int32_t *)&main_testArray, LENGTHOF(main_testArray));
	printf("\n");
	return 0;
}

static void main_print_array(int32_t array[], uint32_t len) {
	printf("\n");
	uint32_t i = 0U;
	while (i < len) {
		printf("array[%i] = %i\n", i, array[i]);
		i = i + 1U;
	}
}

