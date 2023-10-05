
#include <stdio.h>
#include "./utf.h"
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm




#define ratSymbolUTF8  (int8_t [4]){0xF0, 0x9F, 0x90, 0x80}
#define ratSymbolUTF16  (int16_t [2]){0xD83D, 0xDC00}
#define ratSymbolUTF32  0x0001F400


static uint8_t arr_utf8[8] = (uint8_t [8]){72, 101, 108, 111, 33, 10, 0};
static uint16_t arr_utf16[8] = (uint16_t [8]){72, 101, 108, 108, 111, 33, 10, 0};
static uint32_t arr_utf32[8] = (uint32_t [8]){72, 101, 108, 108, 111, 33, 10, 0};


int main(void)
{

    // indexing of GenericString returns #i symbol code
    // the symbols have GenericInteger type
    const uint16_t omegaCharCode = u'Ω';
    const uint32_t ratCharCode = U'🐀';

    // you can assign omegaCharCode (937) to Nat32,
    // but you can't assign ratCharCode (128000) to Nat16 (!)
    uint16_t omegaCode = omegaCharCode;
    uint32_t ratCode = ratCharCode;

    printf((const char *)"omegaCode = %d\n", omegaCode);
    printf((const char *)"ratCode = %d\n", ratCode);


    utf16_puts((uint16_t *)u"Hello Ω!\n");
    utf32_puts((uint32_t *)U"Hello Ω!\n");

    utf32_puts((uint32_t *)U"Hello 🐀!\n");

    return 0;
}

