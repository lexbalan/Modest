
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
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
#define A "A"
static char c8 = A[0];
static char16_t c16 = A[0];
static char32_t c32 = A[0];
static char b8[1] = {'A'};
static char16_t b16[1] = {u'A'};
static char32_t b32[1] = {U'A'};
static char *s8 = A;
static char16_t *s16 = _STR16(A);
static char32_t *s32 = _STR32(A);
static char cc8 = 'A';
static char16_t cc16 = u'A';
static char32_t cc32 = U'A';
static char bb8[1] = {'A'};
static char16_t bb16[1] = {u'A'};
static char32_t bb32[1] = {U'A'};
static char *ss8 = "A";
static char16_t *ss16 = u"A";
static char32_t *ss32 = U"A";
static void putc8(char c);
static void putc16(char16_t c);
static void putc32(char32_t c);
static void puts8(char *s);
static void puts16(char16_t *s);
static void puts32(char32_t *s);

int32_t main(void) {
	printf("test unicode\n");
	putc8(A[0]);
	putc16(A[0]);
	putc32(A[0]);
	puts8(A);
	puts16(_STR16(A));
	puts32(_STR32(A));
	putc8('A');
	putc16(u'A');
	putc32(U'A');
	puts8("A");
	puts16(u"A");
	puts32(U"A");
	return 0;
}

static void putc8(char c) {
	(void)c;
}

static void putc16(char16_t c) {
	(void)c;
}

static void putc32(char32_t c) {
	(void)c;
}

static void puts8(char *s) {
	(void)s;
}

static void puts16(char16_t *s) {
	(void)s;
}

static void puts32(char32_t *s) {
	(void)s;
}

