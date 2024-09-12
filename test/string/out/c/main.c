// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define str8_example  "String"
#define str16_example  (u"String-Ω")
#define str32_example  (U"String-Ω 🐀🎉🦄")
int main();






static char string8[6] = str8_example;
static uint16_t string16[8] = u"String-Ω";
static uint32_t string32[12] = U"String-Ω 🐀🎉🦄";
static char *ptr_to_string8 = str8_example;
static uint16_t *ptr_to_string16 = u"String-Ω";
static uint32_t *ptr_to_string32 = U"String-Ω 🐀🎉🦄";

int main()
{
	putchar_utf8_putchar('A');
	printf("\n");
	putchar_utf16_putchar(u'Ω');
	printf("\n");
	putchar_utf32_putchar(U'🦄');

	printf("\n\n");

	putchar_utf8_puts((char *)&string8);
	printf("\n");
	putchar_utf16_puts((uint16_t *)&string16);
	printf("\n");
	putchar_utf32_puts((uint32_t *)&string32);

	printf("\n\n");

	putchar_utf8_puts(ptr_to_string8);
	printf("\n");
	putchar_utf16_puts(ptr_to_string16);
	printf("\n");
	putchar_utf32_puts(ptr_to_string32);
	printf("\n");

	return 0;
}

