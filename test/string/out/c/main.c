// test/string/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include "./utf.h"





// constants with type String(Generic)
#define str8_example  "String"
#define str16_example  u"String-Ω"
#define str32_example  U"String-Ω 🐀🎉🦄"

// variables with type Array of Chars
static char string8[6] = str8_example;
static uint16_t string16[8] = str16_example;
static uint32_t string32[12] = str32_example;

// variables with type Pointer to Array of Chars
static char *ptr_to_string8 = str8_example;
static uint16_t *ptr_to_string16 = str16_example;
static uint32_t *ptr_to_string32 = str32_example;


int main()
{
	utf8_putchar('A');
	printf("\n");
	utf16_putchar(u'Ω');
	printf("\n");
	utf32_putchar(U'🦄');

	printf("\n\n");

	utf8_puts((char *)&string8);
	printf("\n");
	utf16_puts((uint16_t *)&string16);
	printf("\n");
	utf32_puts((uint32_t *)&string32);

	printf("\n\n");

	utf8_puts(ptr_to_string8);
	printf("\n");
	utf16_puts(ptr_to_string16);
	printf("\n");
	utf32_puts(ptr_to_string32);
	printf("\n");

	return 0;
}

