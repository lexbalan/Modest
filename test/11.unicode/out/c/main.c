
#include <stdio.h>
#include "./utf.h"
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/11.unicode/main.cm




#define ratSymbolUTF8  (uint8_t [4]){0xF0, 0x9F, 0x90, 0x80}
#define ratSymbolUTF16  (uint16_t [2]){0xD83D, 0xDC00}
#define ratSymbolUTF32  0x0001F400


char arr_utf8[8] = (char [8]){'H', 'i', '!', '\xa', '\x0'};
uint16_t arr_utf16[8] = (uint16_t [8]){'H', 'e', 'l', 'l', 'o', '!', '\xa', '\x0'};
uint32_t arr_utf32[8] = (uint32_t [8]){'H', 'e', 'l', 'l', 'o', '!', '\xa', '\x0'};



#define genericStringConst  "S-t-r-i-n-g"
#define string8Const  (genericStringConst)
#define string16Const  (u"S-t-r-i-n-g")
#define string32Const  (U"S-t-r-i-n-g")


int main(void)
{
    // indexing of GenericString returns #i symbol code
    // the symbols have GenericInteger type
    const uint32_t omegaCharCode = u'\x3a9';
    const uint32_t ratCharCode = U'\x1f400';

    // you can assign omegaCharCode (937) to Nat32,
    // but you can't assign ratCharCode (128000) to Nat16 (!)
    uint16_t omegaCode = (uint16_t)omegaCharCode;
    uint32_t ratCode = (uint32_t)ratCharCode;

    printf("omegaCode = %d\n", omegaCode);
    printf("ratCode = %d\n", ratCode);


    utf16_puts(u"Hello Ω!\n");
    utf32_puts(U"Hello Ω!\n");

    utf32_puts(U"Hello 🐀!\n");


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

