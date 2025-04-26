
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "./utf.h"
#include "./console.h"
#include <stdio.h>

#include "main.h"

#define str8_example  "String"
#define str16_example  (u"String-Ω")
#define str32_example  (U"String-Ω 🐀🎉🦄")
static char string8[6] = str8_example;
static uint16_t string16[8] = str16_example;
static uint32_t string32[12] = str32_example;
static char *ptr_to_string8 = str8_example;
static uint16_t *ptr_to_string16 = str16_example;
static uint32_t *ptr_to_string32 = str32_example;

int main()
{
	console_putchar_utf8('A');
	printf("\n");
	console_putchar_utf16(u'Ω');
	printf("\n");
	console_putchar_utf32(U'🦄');

	printf("\n\n");

	console_puts8((char *)&string8);
	printf("\n");
	console_puts16((uint16_t *)&string16);
	printf("\n");
	console_puts32((uint32_t *)&string32);

	printf("\n\n");

	console_puts8(ptr_to_string8);
	printf("\n");
	console_puts16(ptr_to_string16);
	printf("\n");
	console_puts32(ptr_to_string32);
	printf("\n");

	return 0;
}

