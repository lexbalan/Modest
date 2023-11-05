
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
uint16_t arr_utf16[8] = {u'H', u'e', u'l', u'l', u'o', u'!', u'\xa'};
uint32_t arr_utf32[8] = {U'H', U'e', U'l', U'l', U'o', U'!', U'\xa'};



#define genericStringConst  "S-t-r-i-n-g"
#define string8Const  "S-t-r-i-n-g"
#define string16Const  u"S-t-r-i-n-g"
#define string32Const  U"S-t-r-i-n-g"


int main(void)
{
    // indexing of GenericString returns #i symbol code
    // the symbols have GenericInteger type
    //    let omegaCharCode = "Hello Ω!\n"[6]
    //    let ratCharCode = "Hello 🐀!\n"[6]

    // you can assign omegaCharCode (937) to Nat32,
    // but you can't assign ratCharCode (128000) to Nat16 (!)
    //    var omegaCode : Nat16 := omegaCharCode to Nat16
    //    var ratCode : Nat32 := ratCharCode to Nat32

    //    printf("omegaCode = %d\n", omegaCode)
    //    printf("ratCode = %d\n", ratCode)


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

