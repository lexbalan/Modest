// tests/array/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */


#define C0  {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
#define C1  "Hello!"
#define C2  ("Hello!")
#define C3  (_STR16("Hello!"))
#define C4  (_STR32("Hello!"))
#define C5  (32)

static int32_t arr0[10];
static int32_t arr1[10] = C0;
static char32_t arr2[10] = _STR32(C1);


static void printArrayOf10Char32(char32_t *_a);
static void sum10IntArrays(int32_t *_a, int32_t *_b, int32_t *sret_);

int main(void) {
	printf("array test\n");

	int32_t lar0[10];
	int32_t lar1[10] = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90};
	char32_t lar2[10];
	memcpy(&lar2, &arr2, sizeof(char32_t[10]));

	printArrayOf10Char32(lar2);

	sum10IntArrays(arr1, lar1, (int32_t *)&lar0);
	uint32_t i = 0;
	while (i < 10) {
		printf("a[%d] = %d\n", i, lar0[i]);
		i = i + 1;
	}

	return 0;
}


static void printArrayOf10Char32(char32_t *_a) {
	char32_t a[10];
	memcpy(a, _a, sizeof(char32_t[10]));
	uint32_t i = 0;
	while (i < LENGTHOF(a)) {
		printf("a[%d] = '%c'\n", i, a[i]);
		i = i + 1;
	}
}


static void sum10IntArrays(int32_t *_a, int32_t *_b, int32_t *sret_) {
	int32_t a[10];
	memcpy(a, _a, sizeof(int32_t[10]));
	int32_t b[10];
	memcpy(b, _b, sizeof(int32_t[10]));
	int32_t result[10];
	uint32_t i = 0;
	while (i < 10) {
		result[i] = a[i] + b[i];
		i = i + 1;
	}
	memcpy(sret_, &result, sizeof(int32_t[10]));
}


