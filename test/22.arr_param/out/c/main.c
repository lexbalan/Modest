
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>



// returns array by value
static void main_getarr10(int32_t *sret_)
{
	memcpy(sret_, &(int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9	}, sizeof(int32_t[10]));
}


// receive & returns array by value
static void main_arraysAdd(int32_t *_a, int32_t *_b, int32_t *sret_)
{
	int32_t a[10];
	memcpy(a, _a, sizeof(int32_t[10]));
	int32_t b[10];
	memcpy(b, _b, sizeof(int32_t[10]));
	int32_t c[10];
	memset(&c, 0, sizeof c);
	int32_t i = 0;
	while (i < 10) {
		c[i] = a[i] + b[i];
		i = i + 1;
	}
	memcpy(sret_, &c, sizeof(int32_t[10]));
}


int32_t main()
{
	int32_t a[10];
	main_getarr10(&a);

	if (memcmp(&a, &(int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9	}, sizeof(int32_t[10])) == 0) {
		printf("test1 passed!\n");
	}

	#define __b  {0, 10, 20, 30, 40, 50, 60, 70, 80, 90	}

	int32_t c[10];
	main_arraysAdd(a, (int32_t[10])__b, &c);

	if (memcmp(&c, &(int32_t[10]){0, 11, 22, 33, 44, 55, 66, 77, 88, 99	}, sizeof(int32_t[10])) == 0) {
		printf("test2 passed!\n");
	}

	int32_t d[10];
	main_arraysAdd(a, a, &d);

	if (memcmp(&d, &(int32_t[10]){0, 2, 4, 6, 8, 10, 12, 14, 16, 18	}, sizeof(int32_t[10])) == 0) {
		printf("test3 passed!\n");
	}

	int32_t i = 0;
	while (i < 10) {
		printf("d[%i] = %i\n", i, d[i]);
		i = i + 1;
	}

	return 0;

#undef __b
}

