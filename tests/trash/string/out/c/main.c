
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./utf.h"
#include "./console.h"
#include "console.h"
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
#define MAIN_STR8_EXAMPLE "String"
#define MAIN_STR16_EXAMPLE MAIN_STR8_EXAMPLE "-Ω"
#define MAIN_STR32_EXAMPLE MAIN_STR16_EXAMPLE " 🐀🎉🦄"
static char main_string8[6] = {'S', 't', 'r', 'i', 'n', 'g'};
static char16_t main_string16[8] = {u'S', u't', u'r', u'i', u'n', u'g', u'-', u'Ω'};
static char32_t main_string32[12] = {U'S', U't', U'r', U'i', U'n', U'g', U'-', U'Ω', U' ', U'🐀', U'🎉', U'🦄'};
static char *main_ptr_to_string8 = MAIN_STR8_EXAMPLE;
static char16_t *main_ptr_to_string16 = _STR16(MAIN_STR16_EXAMPLE);
static char32_t *main_ptr_to_string32 = _STR32(MAIN_STR32_EXAMPLE);

int main(void) {
	console_putchar_utf8('A');
	printf("\n");
	console_putchar_utf16(u'Ω');
	printf("\n");
	console_putchar_utf32(U'🦄');
	printf("\n");
	printf("\n");
	console_puts8(main_string8);
	printf("\n");
	console_puts16(main_string16);
	printf("\n");
	console_puts32(main_string32);
	printf("\n");
	printf("\n");
	console_puts8(main_ptr_to_string8);
	printf("\n");
	console_puts16(main_ptr_to_string16);
	printf("\n");
	console_puts32(main_ptr_to_string32);
	printf("\n");
	return 0;
}

