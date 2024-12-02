// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"




static void getarr10(int32_t __retval[10])
{
	memcpy(__retval, &(int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, sizeof(int32_t[10]));
}

static void arrAddToAll(int32_t __retval[10], int32_t __a[10], int32_t x)
{
	int32_t a[10];
	memcpy(a, __a, sizeof(int32_t[10]));
	int32_t b[10];
	int32_t i = 0;
	while (i < 10) {
		b[i] = a[i] + x;
		i = i + 1;
	}
	memcpy(__retval, &b, sizeof(int32_t[10]));
}

int32_t main()
{
	int32_t a[10];
	getarr10(a);

	if (memcmp(&a, &(int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, sizeof(int32_t[10])) == 0) {
		printf("test1 passed!\n");
	}

	int32_t b[10];
	arrAddToAll(b, a, 1);

	if (memcmp(&b, &(int32_t[10]){1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, sizeof(int32_t[10])) == 0) {
		printf("test2 passed!\n");
	}

	int32_t c[10];
	arrAddToAll(c, (int32_t[10]){0, 10, 20, 30, 40, 50, 60, 70, 80, 90}, 5);

	if (memcmp(&c, &(int32_t[10]){5, 15, 25, 35, 45, 55, 65, 75, 85, 95}, sizeof(int32_t[10])) == 0) {
		printf("test3 passed!\n");
	}

	int32_t i = 0;
	while (i < 10) {
		printf("c[%i] = %i\n", i, c[i]);
		i = i + 1;
	}

	return 0;
}

