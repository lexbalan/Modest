
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

static void main_getarr10(int32_t __out[10]) {
	__builtin_memcpy(__out, &(int32_t [10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, sizeof(int32_t [10]));
}

static void main_arraysAdd(int32_t _a[10], int32_t _b[10], int32_t __out[10]) {
	int32_t b[10];
	__builtin_memcpy(b, _b, sizeof(int32_t [10]));
	int32_t a[10];
	__builtin_memcpy(a, _a, sizeof(int32_t [10]));
	int32_t c[10];
	uint32_t i = 0U;
	while (i < 10U) {
		c[i] = a[i] + b[i];
		i = i + 1U;
	}
	__builtin_memcpy(__out, &c, sizeof(int32_t [10]));
}

int32_t main(void) {
	int32_t main_a[10];
	main_getarr10(main_a);
	if (__builtin_memcmp(&main_a, &(const int32_t [10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, sizeof(const int32_t [10])) == 0) {
		printf("test1 passed!\n");
	}
	#define main_b {0, 10, 20, 30, 40, 50, 60, 70, 80, 90}
	int32_t main_c[10];
	main_arraysAdd(main_a, (int32_t *)&(int32_t [10])main_b, main_c);
	if (__builtin_memcmp(&main_c, &(const int32_t [10]){0, 11, 22, 33, 44, 55, 66, 77, 88, 99}, sizeof(const int32_t [10])) == 0) {
		printf("test2 passed!\n");
	}
	int32_t main_d[10];
	main_arraysAdd(main_a, main_a, main_d);
	if (__builtin_memcmp(&main_d, &(const int32_t [10]){0, 2, 4, 6, 8, 10, 12, 14, 16, 18}, sizeof(const int32_t [10])) == 0) {
		printf("test3 passed!\n");
	}
	uint32_t i = 0U;
	while (i < 10U) {
		printf("d[%i] = %i\n", i, main_d[i]);
		i = i + 1U;
	}
	return 0;
	#undef main_b
}

