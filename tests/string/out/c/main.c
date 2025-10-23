// tests/string/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./utf.h"
#include "./console.h"



// constants with type String(Generic)
#define STR8_EXAMPLE  "String"
#define STR16_EXAMPLE  "String-Ω"
#define STR32_EXAMPLE  "String-Ω 🐀🎉🦄"

// variables with type Array of Chars
static char string8[6] = STR8_EXAMPLE;
static char16_t string16[8] = _STR16(STR16_EXAMPLE);
static char32_t string32[12] = _STR32(STR32_EXAMPLE);

// variables with type Pointer to Array of Chars
static char *ptr_to_string8 = STR8_EXAMPLE;
static char16_t *ptr_to_string16 = _STR16(STR16_EXAMPLE);
static char32_t *ptr_to_string32 = _STR32(STR32_EXAMPLE);

int main() {
	console_putchar_utf8('A');
	printf("\n");
	console_putchar_utf16(u'Ω');
	printf("\n");
	console_putchar_utf32(U'🦄');
	printf("\n");

	printf("\n");

	console_puts8((char *)&string8);
	printf("\n");
	console_puts16((char16_t *)&string16);
	printf("\n");
	console_puts32((char32_t *)&string32);
	printf("\n");

	printf("\n");

	console_puts8(ptr_to_string8);
	printf("\n");
	console_puts16(ptr_to_string16);
	printf("\n");
	console_puts32(ptr_to_string32);
	printf("\n");

	return 0;
}


