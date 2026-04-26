
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
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
#define MAIN_UTF8_CHAR "s"
#define MAIN_UTF16_CHAR "Я"
#define MAIN_UTF32_CHAR "🐀"

int main(void) {
	printf("test/char\n");
	char ch08;
	char16_t ch16;
	char32_t ch32;
	ch08 = MAIN_UTF8_CHAR[0];
	ch16 = MAIN_UTF16_CHAR[0];
	ch32 = MAIN_UTF32_CHAR[0];
	printf("ch08 = 0x%x (%c)\n", (uint32_t)(uint8_t)ch08, ch08);
	printf("ch16 = 0x%x (%c)\n", (uint32_t)(uint16_t)ch16, ch16);
	printf("ch32 = 0x%x (%c)\n", (uint32_t)ch32, ch32);
	return 0;
}

