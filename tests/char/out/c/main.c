// tests/char/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



#define UTF8_CHAR  "s"
#define UTF16_CHAR  "Я"
#define UTF32_CHAR  "🐀"

int main(void) {
	printf("test/char\n");

	char ch08;
	char16_t ch16;
	char32_t ch32;

	ch08 = _CHR8(UTF8_CHAR);
	ch16 = _CHR16(UTF16_CHAR);
	ch32 = _CHR32(UTF32_CHAR);

	printf("ch08 = 0x%x (%c)\n", (uint32_t)(uint8_t)ch08, ch08);
	printf("ch16 = 0x%x (%c)\n", (uint32_t)(uint16_t)ch16, ch16);
	printf("ch32 = 0x%x (%c)\n", (uint32_t)ch32, ch32);

	return 0;
}


