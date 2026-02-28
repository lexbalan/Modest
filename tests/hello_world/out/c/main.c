
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#ifndef __STR_UNICODE__
#if __has_include(<uchar.h>)
#include <uchar.h>
#else
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#endif
#define __STR_UNICODE__
#define __STR8(x)  x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x)  __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#define _CHR8(x)  (__STR8(x)[0])
#define _CHR16(x) (__STR16(x)[0])
#define _CHR32(x) (__STR32(x)[0])
#endif /* __STR_UNICODE__ */


#include <stdlib.h>



struct point {int64_t x; int64_t y;};

static void foo(int32_t a, int64_t b) {
	return;
}


#define C  15

//var a: Int32 = 5
static int32_t k[3] = {1, 2, 3};

static struct point p0 = (struct point){.x = 1, .y = 2};

int main(void) {

	const char xc1 = 'A';
	const char16_t xc2 = u'A';
	const char32_t xc3 = U'A';

	char xcs1[1] = "A";
	char16_t xcs2[1] = u"A";
	char32_t xcs3[1] = U"A";

	char *const xs1 = "A";
	char16_t *const xs2 = u"A";
	char32_t *const xs3 = U"A";


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
	#define kk  (1 + 2 - 3 * 4)

	(void)a;
	(uint32_t)abs(a);
	(uint64_t)llabs(b);

	arr[1];
	struct point p0 = (struct point){};
	if (a < 1 && b > 12 || C <= 5 && !(1 < 0)) {
		uint32_t u;
		uint32_t v;
		u | v & u ^ ~v;
		u << 10;v >> 20;
		int32_t *const pa = &a;
		*pa;
		((int64_t)a + b);
		+a;
		-a;
		a = a + 1;
		a = a - 1;
	}

	true || false;

	#define pi  3.1415

	float f;
	f = pi;

	return 0;

#undef kk
#undef pi
}


