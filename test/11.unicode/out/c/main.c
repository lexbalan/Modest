// test/11.unicode/main.cm

#include <string.h>
#include <stdio.h>
#include "./utf.h"
#include <stdint.h>
#include <stdbool.h>

#define ratSymbolUTF32  0x0001F400


static char arr_utf8[8] = {'H', 'i', '!', '\xA', '\0', '\0', '\0', '\0'};;
static uint16_t arr_utf16[8] = u"Hello!\n";;
static uint32_t arr_utf32[8] = U"Hello!\n";;
#define string8Const  "S-t-r-i-n-g-Ω 🐀🎉🦄"
#define string16Const  u"S-t-r-i-n-g-Ω 🐀🎉🦄"
#define string32Const  U"S-t-r-i-n-g-Ω 🐀🎉🦄"


int main()
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


    int32_t i = 0;
    while (true) {
        const uint16_t c = string16Const[i];
        if (c == 0) {
            break;
        }

        printf("[%d]U16: 0x%x\n", i, (uint32_t)c);

        i = i + 1;
    }

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

