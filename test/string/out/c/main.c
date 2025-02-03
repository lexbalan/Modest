
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"
#include "./utf.h"
#include "./console.h"
#include <stdio.h>



// constants with type String(Generic)
#define main_str8_example  "String"
#define main_str16_example  (u"String-Ω")
#define main_str32_example  (U"String-Ω 🐀🎉🦄")

// variables with type Array of Chars
static char main_string8[6] = main_str8_example;
static uint16_t main_string16[8] = u"String-Ω";
static uint32_t main_string32[12] = U"String-Ω 🐀🎉🦄";

// variables with type Pointer to Array of Chars
static char *main_ptr_to_string8 = main_str8_example;
static uint16_t *main_ptr_to_string16 = u"String-Ω";
static uint32_t *main_ptr_to_string32 = U"String-Ω 🐀🎉🦄";


int main()
{
	console_putchar_utf8('A');
	printf("\n");
	console_putchar_utf16(u'Ω');
	printf("\n");
	console_putchar_utf32(U'🦄');

	printf("\n\n");

	console_puts8((char *)&main_string8);
	printf("\n");
	console_puts16((uint16_t *)&main_string16);
	printf("\n");
	console_puts32((uint32_t *)&main_string32);

	printf("\n\n");

	console_puts8(main_ptr_to_string8);
	printf("\n");
	console_puts16(main_ptr_to_string16);
	printf("\n");
	console_puts32(main_ptr_to_string32);
	printf("\n");

	return 0;
}

