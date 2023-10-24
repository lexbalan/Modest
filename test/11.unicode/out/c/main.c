
#include <stdio.h>
#include "./utf.h"
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/11.unicode/main.cm




#define ratSymbolUTF8  (uint8_t [4]){0xF0, 0x9F, 0x90, 0x80}
#define ratSymbolUTF16  (uint16_t [2]){0xD83D, 0xDC00}
#define ratSymbolUTF32  0x0001F400


char arr_utf8[8] = {'H', 'i', '!', '\xa'};
uint16_t arr_utf16[8] = {'H', 'e', 'l', 'l', 'o', '!', '\xa'};
uint32_t arr_utf32[8] = {'H', 'e', 'l', 'l', 'o', '!', '\xa'};



#define genericStringConst  "S-t-r-i-n-g"
#define string8Const  "S-t-r-i-n-g"
#define string16Const  u"S-t-r-i-n-g"
#define string32Const  U"S-t-r-i-n-g"


int main(void)
{
    // indexing of GenericString returns #i symbol code
    // the symbols have GenericInteger type
    const char omegaCharCode = u'\x3a9';
    const char ratCharCode = U'\x1f400';

    // you can assign omegaCharCode (937) to Nat32,
    // but you can't assign ratCharCode (128000) to Nat16 (!)
    uint16_t omegaCode = (uint16_t)omegaCharCode;
    uint32_t ratCode = (uint32_t)ratCharCode;

    printf("omegaCode = %d\n", omegaCode);
    printf("ratCode = %d\n", ratCode);


    utf16_puts(u"Hello \x3a9!\n");
    utf32_puts(U"Hello \x3a9!\n");

    utf32_puts(U"Hello \x1f400!\n");


    char *str8 = string8Const;
    uint16_t *str16 = string16Const;
    uint32_t *str32 = string32Const;

    utf8_puts(str8);
    utf8_puts("\n");

    utf16_puts(str16);
    utf8_puts("\n");

    utf32_puts(str32);
    utf8_puts("\n");

    return 0;
}

