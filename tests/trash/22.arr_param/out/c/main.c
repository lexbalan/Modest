
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

static void getarr10(int32_t __out[10]) {
	__builtin_memcpy(__out, &(int32_t [10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, sizeof(int32_t [10]));
}

static void arraysAdd(int32_t _a[10], int32_t _b[10], int32_t __out[10]) {
	int32_t b[10];
	__builtin_memcpy(b, _b, sizeof(int32_t [10]));
	int32_t a[10];
	__builtin_memcpy(a, _a, sizeof(int32_t [10]));
	int32_t c[10];
	uint32_t i = 0;
	while (i < 10) {
		c[i] = a[i] + b[i];
		i = i + 1;
	}
	__builtin_memcpy(__out, &c, sizeof(int32_t [10]));
}

int32_t main(void) {
	int32_t a[10];
	getarr10(a);
	if (__builtin_memcmp(&a, &(const int32_t [10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, sizeof(const int32_t [10])) == 0) {
		printf("test1 passed!\n");
	}
	#define b {0, 10, 20, 30, 40, 50, 60, 70, 80, 90}
	int32_t c[10];
	arraysAdd(a, (int32_t *)&(int32_t [10])b, c);
	if (__builtin_memcmp(&c, &(const int32_t [10]){0, 11, 22, 33, 44, 55, 66, 77, 88, 99}, sizeof(const int32_t [10])) == 0) {
		printf("test2 passed!\n");
	}
	int32_t d[10];
	arraysAdd(a, a, d);
	if (__builtin_memcmp(&d, &(const int32_t [10]){0, 2, 4, 6, 8, 10, 12, 14, 16, 18}, sizeof(const int32_t [10])) == 0) {
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

