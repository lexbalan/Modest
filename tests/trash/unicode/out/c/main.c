
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
#define MAIN_A "A"
static char main_c8 = MAIN_A[0];
static char16_t main_c16 = MAIN_A[0];
static char32_t main_c32 = MAIN_A[0];
static char main_b8[1] = {'A'};
static char16_t main_b16[1] = {u'A'};
static char32_t main_b32[1] = {U'A'};
static char *main_s8 = MAIN_A;
static char16_t *main_s16 = _STR16(MAIN_A);
static char32_t *main_s32 = _STR32(MAIN_A);
static char main_cc8 = 'A';
static char16_t main_cc16 = u'A';
static char32_t main_cc32 = U'A';
static char main_bb8[1] = {'A'};
static char16_t main_bb16[1] = {u'A'};
static char32_t main_bb32[1] = {U'A'};
static char *main_ss8 = "A";
static char16_t *main_ss16 = u"A";
static char32_t *main_ss32 = U"A";
static void main_putc8(char c);
static void main_putc16(char16_t c);
static void main_putc32(char32_t c);
static void main_puts8(char *s);
static void main_puts16(char16_t *s);
static void main_puts32(char32_t *s);

int32_t main(void) {
	printf("test unicode\n");
	main_putc8(MAIN_A[0]);
	main_putc16(MAIN_A[0]);
	main_putc32(MAIN_A[0]);
	main_puts8(MAIN_A);
	main_puts16(_STR16(MAIN_A));
	main_puts32(_STR32(MAIN_A));
	main_putc8('A');
	main_putc16(u'A');
	main_putc32(U'A');
	main_puts8("A");
	main_puts16(u"A");
	main_puts32(U"A");
	return 0;
}

static void main_putc8(char c) {
	(void)c;
}

static void main_putc16(char16_t c) {
	(void)c;
}

static void main_putc32(char32_t c) {
	(void)c;
}

static void main_puts8(char *s) {
	(void)s;
}

static void main_puts16(char16_t *s) {
	(void)s;
}

static void main_puts32(char32_t *s) {
	(void)s;
}

