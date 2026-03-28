
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
#include <stdlib.h>
#include <stdarg.h>
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
	__builtin_memcpy(_sret_, &(int32_t [3]){1, 2, 3}, sizeof(int32_t [3]));
}

static void facc(int32_t (*_a)[3]) {
	int32_t a[3];
	__builtin_memcpy(a, _a, sizeof(int32_t [3]));
}

static void fpacc(int32_t (*a)[3]) {
	(*a)[1] = 1;
	int32_t slice[1 - 0];
	__builtin_memcpy(&slice, (int32_t (*)[1 - 0])&(*a)[0], sizeof(const int32_t [1 - 0]));
}

static void fpacc2(char *(*argv)[]) {
}

static void fpacc3(int32_t (*a)[3][3]) {
	(*a)[0][0] = 1;
}

int main(void) {
	typedef int32_t LocalInt;
	#define c00 10
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
	char cs1[1] = {'B'};
	char16_t cs2[1] = {u'B'};
	char32_t cs3[1] = {U'B'};
	char *s1 = "B";
	char16_t *s2 = u"B";
	char32_t *s3 = U"B";
	uint64_t w = 0x1LL << 63;
	printf("w = %llx\n", w);
	int16_t x1 = -1;
	uint32_t x2 = (uint32_t)(uint16_t)x1;
	printf("x2 = %llx\n", x2);
	if (x2 != 0xFFFF) {
	}
	int32_t arr[3] = {1, 2, 3};
	int32_t arr2[3];
	__builtin_memcpy(&arr2, &arr, sizeof(int32_t [3]));
	int32_t arr4[3];
	__builtin_memcpy(&arr4, &arr, sizeof(const int32_t [3]));
	int32_t arr3[3];
	farr(&arr2);
	__builtin_bzero(&arr2, sizeof(int32_t [3]));
	__builtin_memcpy(&arr2, &arr, sizeof(int32_t [3]));
	facc(&arr2);
	#define rec0 {.x = 0, .y = 0}
	struct point rec1 = (struct point)rec0;
	struct point rec2;
	rec2 = (struct point){0};
	rec2 = rec1;
	LENGTHOF(arr);
	printf("Hello World!\n");
	int32_t a;
	int64_t b;
	a + 2;
	a - 2;
	a * 2;
	a / 2;
	a % 2;
	foo(1, 2LL);
	foo(a + 1, b - C);
	#define kk (1 + 2 - 3 * 4)
	#define pp 3.1415
	(void)a;
	(uint32_t)abs(a);
	(uint64_t)llabs(b);
	sizeof a;
	sizeof(uint32_t);
	arr[1];
	struct point p0 = (struct point){0};
	p0.x;
	p0.y;
	if (a < 1 && b > 12LL || C <= 5 && !(1 < 0)) {
		uint32_t u;
		uint32_t v;
		u | (v & u) ^ ~v;
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
		#define u 129
		break;
	}
	if (1 < 2) {
	} else if (2 > 3) {
	} else {
	}
	true || false;
	#define pi 3.1415
	float f;
	f = pi;
	return 0;
	#undef c00
	#undef rec0
	#undef kk
	#undef pp
	#undef u
	#undef pi
}
//func sum64 (a: Int64, b: Int64) -> Int64 {
//	var sum: Int64
//	__asm("add %0, %1, %2", [["=r", sum]], [["r", a]["r", b]], ["cc"])
//	return sum
//}

void main_print(char *form, ...) {
	va_list va;
	va_list va2;
	va_start(va, form);
	va_copy(va2, va);
	va_end(va);
}

