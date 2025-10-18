// tests/char/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


#define utf8Char  "s"
#define utf16Char  "Я"
#define utf32Char  "🐀"

int main() {
	printf("test/char\n");

	char ch08;
	char16_t ch16;
	char32_t ch32;

	ch08 = utf8Char[0];
	ch16 = _STR16(utf16Char)[0];
	ch32 = _STR32(utf32Char)[0];

	//printf("ch08 = 0x%x (%c)\n", Nat32 ch08, ch08)
	//printf("ch16 = 0x%x (%c)\n", Nat32 ch16, ch16)
	//printf("ch32 = 0x%x (%c)\n", Nat32 ch32, ch32)

	return 0;
}


