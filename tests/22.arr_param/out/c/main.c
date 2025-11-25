
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



// returns array by value

// returns array by value
static void getarr10(int32_t *sret_) {
	memcpy(sret_, &((int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9}), sizeof(int32_t[10]));
}


// receive & returns array by value
static void arraysAdd(int32_t *_a, int32_t *_b, int32_t *sret_) {
	int32_t a[10];
	memcpy(a, _a, sizeof(int32_t[10]));
	int32_t b[10];
	memcpy(b, _b, sizeof(int32_t[10]));
	int32_t c[10];
	uint32_t i = 0;
	while (i < 10) {
		c[i] = a[i] + b[i];
		i = i + 1;
	}
	memcpy(sret_, &c, sizeof(int32_t[10]));
}


int32_t main(void) {
	int32_t a[10];
	getarr10((int32_t *)&a);

	if (memcmp(&a, &((int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9}), sizeof(int32_t[10])) == 0) {
		printf("test1 passed!\n");
	}

	#define b  {0, 10, 20, 30, 40, 50, 60, 70, 80, 90}

	int32_t c[10];
	arraysAdd(a, (int32_t[10])b, (int32_t *)&c);

	if (memcmp(&c, &((int32_t[10]){0, 11, 22, 33, 44, 55, 66, 77, 88, 99}), sizeof(int32_t[10])) == 0) {
		printf("test2 passed!\n");
	}

	int32_t d[10];
	arraysAdd(a, a, (int32_t *)&d);

	if (memcmp(&d, &((int32_t[10]){0, 2, 4, 6, 8, 10, 12, 14, 16, 18}), sizeof(int32_t[10])) == 0) {
		printf("test3 passed!\n");
	}

	uint32_t i = 0;
	while (i < 10) {
		printf("d[%i] = %i\n", i, d[i]);
		i = i + 1;
	}

	return 0;

#undef b
}


