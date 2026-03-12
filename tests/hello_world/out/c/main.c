
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */
#include <stdlib.h>
#include <stdarg.h>

#if !defined(__STR_UNICODE__)
#define __STR_UNICODE__
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#endif
typedef int32_t MyInt;
struct point {
	uint64_t x;
	uint64_t y;
};
typedef struct open_point OpenPoint;
struct open_point {
	uint64_t x;
	uint64_t y;
};
struct list_header;
typedef struct list_header ListHeader;
struct list_header {
	ListHeader *next;
	ListHeader *prev;
};

static void foo(int32_t a, int64_t b) {
	return;
}
#define C 15
static uint32_t k[3] = {0x1, 0x2, 0x3};
static struct point p0 = (struct point){
	.x = 1,
	.y = 2
};

static void farr(int32_t (*_sret_)[3]) {
	memcpy(_sret_, &(int32_t [3]){1, 2, 3}, sizeof(int32_t [3]));
}

static void facc(int32_t (*_a)[3]) {
	int32_t a[3];
	memcpy(a, _a, sizeof(int32_t [3]));
}

int main(void) {
	const int8_t c00 = 10;
	const char xc1 = 'A';
	const char16_t xc2 = u'A';
	const char32_t xc3 = U'A';
	const char xcs1[1] = "A";
	const char16_t xcs2[1] = u"A";
	const char32_t xcs3[1] = U"A";
	char *const xs1 = "A";
	char16_t *const xs2 = u"A";
	char32_t *const xs3 = U"A";
	int32_t v00 = 10;
	char c1 = 'B';
	char16_t c2 = u'B';
	char32_t c3 = U'B';
	char cs1[1] = "B";
	char16_t cs2[1] = u"B";
	char32_t cs3[1] = U"B";
	char *s1 = "B";
	char16_t *s2 = u"B";
	char32_t *s3 = U"B";
	int32_t arr[3] = {1, 2, 3};
	int32_t arr2[3];
	memcpy(&arr2, &arr, sizeof(int32_t [3]));
	const int32_t arr4[3];
	memcpy(&arr4, &arr, sizeof(const int32_t [3]));
	int32_t arr3[3];
	farr(&arr2);
	memset(&arr2, 0, sizeof(int32_t [3]));
	memcpy(&arr2, &arr, sizeof(int32_t [3]));
	facc(&arr2);
	struct point rec = (struct point){.x = 0, .y = 0};
	struct point rec2;
	rec2 = (struct point){0};
	rec2 = rec;
	LENGTHOF(arr);
	printf("Hello World!\n");
	int32_t a;
	int64_t b;
	a + 2;
	a - 2;
	a * 2;
	a / 2;
	a % 2;
	foo(1, 2);
	foo(a + 1, b - C);
	const int8_t kk = 1 + 2 - 3 * 4;
	const double pp = 3.1415;
	(void)a;
	(uint32_t)abs(a);
	(uint64_t)llabs(b);
	sizeof a;
	sizeof(uint32_t);
	arr[1];
	struct point p0 = (struct point){0};
	p0.x;
	p0.y;
	if (a < 1 && b > 12 || C <= 5 && !(1 < 0)) {
		uint32_t u;
		uint32_t v;
		u | ((v & u) ^ ~v);
		u << 10;
		v >> 20;
		int32_t *const pa = &a;
		*pa;
		(int64_t)a + b;
		+a;
		-a;
		a = a + 1;
		a = a - 1;
	}
	while (1 > 0) {
		const int8_t u = 129;
	}
	if (1 < 2) {
	} else if (2 > 3) {
	} else {
	}
	true || false;
	const double pi = 3.1415;
	float f;
	f = pi;
	return 0;
}

void main_print(char *form, ...) {
	va_list va;
	va_list va2;
	va_start(va, form);
	va_copy(va2, va);
	va_end(va);
}

