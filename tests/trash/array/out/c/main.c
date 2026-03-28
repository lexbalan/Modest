
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
#if !defined(__STR_UNICODE__)
#define __STR_UNICODE__
typedef uint8_t char8_t;
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#define __STR8(x) x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x) __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#endif
#define C0 {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
#define C1 "Hello!"
#define C2 "Hello!"
#define C3 u"Hello!"
#define C4 U"Hello!"
#define C5 32
static int32_t arr0[10];
static int32_t arr1[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
static char32_t arr2[10] = {U'H', U'e', U'l', U'l', U'o', U'!'};
//func f0 (x: []Int32) -> []Int32 {
//	var aa: []Int32
//	var ab: [0]Int32
//}
static void printArrayOf10Char32(char32_t *_a);
static void sum10IntArrays(int32_t (*_a)[10], int32_t (*_b)[10], int32_t (*_sret_)[10]);

int main(void) {
	printf("array test\n");
	int32_t lar0[10];
	int32_t lar1[10] = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90};
	char32_t lar2[10];
	__builtin_memcpy(&lar2, &arr2, sizeof(char32_t [10]));
	printArrayOf10Char32(lar2);
	sum10IntArrays(&arr1, &lar1, &lar0);
	uint32_t i = 0U;
	while (i < 10U) {
		printf("a[%d] = %d\n", i, lar0[i]);
		i = i + 1U;
	}
	return 0;
}

static void printArrayOf10Char32(char32_t *_a) {
	char32_t a[10];
	__builtin_memcpy(a, _a, sizeof(char32_t [10]));
	uint32_t i = 0U;
	while (i < LENGTHOF(a)) {
		printf("a[%d] = '%c'\n", i, a[i]);
		i = i + 1U;
	}
}

static void sum10IntArrays(int32_t (*_a)[10], int32_t (*_b)[10], int32_t (*_sret_)[10]) {
	int32_t b[10];
	__builtin_memcpy(b, _b, sizeof(int32_t [10]));
	int32_t a[10];
	__builtin_memcpy(a, _a, sizeof(int32_t [10]));
	int32_t result[10];
	uint32_t i = 0U;
	while (i < 10U) {
		result[i] = a[i] + b[i];
		i = i + 1U;
	}
	__builtin_memcpy(_sret_, &result, sizeof(int32_t [10]));
}

