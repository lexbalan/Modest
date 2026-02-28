
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




static void foo(int32_t a, int64_t b) {
	return;
}


#define C  15

int main(void) {
	printf("Hello World!\n");

	char c1 = 'A';
	char16_t c2 = u'A';
	char32_t c3 = U'A';

	char *s1 = "Hi!";
	char16_t *s2 = u"Hi!∆";
	char32_t *s3 = U"Hi!∆";

	char cs1[3] = "Hi!";
	char16_t cs2[4] = u"Hi!∆";
	char32_t cs3[4] = U"Hi!∆";

	int32_t a;
	int64_t b;
	foo((int32_t)1, (int64_t)2);
	foo(a + (int32_t)1, b - (int64_t)c);
	(int4_t)(1 + 2) - 3 * 4;
	int32_t arr[3] = (int32_t [3]){1, 2, 3};
	arr[(int32_t)1];
	if (a < (int32_t)1 && b > (int64_t)12 || c <= 5 && !1 < 0) {
		uint32_t u;
		uint32_t v;
		u | v & u ^ v;
		u << 10;v >> 20;
		int32_t *const pa = &a;
		*pa;
		((int64_t)a + b);
		+a;
		-a;
	}

	true || false;

	#define pi  3.1415

	float f;
	f = (float)pi;



	return (int)0;

#undef pi
}


