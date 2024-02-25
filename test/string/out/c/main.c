// test/string/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include "./utf.h"





static char string8[12] = "S-t-r-i-n-g";;
static uint16_t string16[14] = u"S-t-r-i-n-g-Ω";;
static uint32_t string32[18] = U"S-t-r-i-n-g-Ω 🐀🎉🦄";;

static char *ptr_to_string8 = "S-t-r-i-n-g";
static uint16_t *ptr_to_string16 = u"S-t-r-i-n-g-Ω";
static uint32_t *ptr_to_string32 = U"S-t-r-i-n-g-Ω 🐀🎉🦄";


void putc8(char c)
{
    printf("%c", c);
}

void putc16(uint16_t c)
{
    printf("%c", c);
}


int main()
{
    utf8_putchar('A');
    printf("\n");
    utf16_putchar(u'Ω');
    printf("\n");
    utf32_putchar(U'🦄');

    printf("\n\n");

    utf8_puts((char *)(char *)&string8);
    printf("\n");
    utf16_puts((uint16_t *)(uint16_t *)&string16);
    printf("\n");
    utf32_puts((uint32_t *)(uint32_t *)&string32);

    printf("\n\n");

    utf8_puts(ptr_to_string8);
    printf("\n");
    utf16_puts(ptr_to_string16);
    printf("\n");
    utf32_puts(ptr_to_string32);
    printf("\n");

    return 0;
}

