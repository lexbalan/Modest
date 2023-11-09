
#include <stdio.h>
#include "./utf.h"
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/11.unicode/main.cm




#define ratSymbolUTF8  (uint8_t [4]){0xF0, 0x9F, 0x90, 0x80}
#define ratSymbolUTF16  (uint16_t [2]){0xD83D, 0xDC00}
#define ratSymbolUTF32  0x0001F400


char arr_utf8[8] = {'H', 'i', '!', '\xA'};
uint16_t arr_utf16[8] = {u'H', u'e', u'l', u'l', u'o', u'!', u'\xA'};
uint32_t arr_utf32[8] = {U'H', U'e', U'l', U'l', U'o', U'!', U'\xA'};



#define genericStringConst  {} /*GENERIC-STRING*/
#define string8Const  "S-t-r-i-n-g-\xce\xa9 \xf0\x9f\x90\x80\xf0\x9f\x8e\x89\xf0\x9f\xa6\x84\n"
#define string16Const  u"S-t-r-i-n-g-\x3a9 \xd83d\xdc00\xd83c\xdf89\xd83e\xdd84\n"
#define string32Const  U"S-t-r-i-n-g-\x3a9 \x1f400\x1f389\x1f984\n"


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


    int i = 0;
    while (true) {
        const uint16_t c = string16Const[i];
        if (c == 0) {
            break;
        }

        printf("[%d]U16: 0x%x\n", i, ((uint32_t)(uint16_t)c));

        i = i + 1;
    }


    const uint32_t a = u'\x3A9';
    uint16_t ch16_str[3];
    //ch16_str[0] := a
    //ch16_str[1] := "\0"[0]

    //utf16_puts(&ch16_str to *Str16)

    printf("\n");


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

