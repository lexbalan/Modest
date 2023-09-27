
#include <stdio.h>
#include "./utf.h"
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm


/*
@property("c_alias", "wchar_t")
type WChar Int16

@property("c_alias", "wchar_t *")
type WCharStr16 *[]Nat16


@attribute(["arghack", "dispensable", "c-no-print"])
extern func wprintf(s : WCharStr16) -> Int


@attribute(["dispensable", "c-no-print"])
extern func putwchar(c : WChar) -> Int
*/


/*
    UTF-8 Encoding:	    0xF0 0x9F 0x90 0x80
    UTF-16 Encoding:	0xD83D 0xDC00
    UTF-32 Encoding:	0x0001F400
*/

#define ratUTF8  (int8_t [4]){0xF0, 0x9F, 0x90, 0x80}
#define ratUTF16  (int16_t [2]){0xD83D, 0xDC00}
#define ratUTF32  0x0001F400


// TODO: перекрытие имен - что с этим делать???


static uint8_t arr_utf8[8] = (uint8_t [8]){72, 101, 108, 111, 33, 10, 0};
static uint16_t arr_utf16[8] = (uint16_t [8]){72, 101, 108, 108, 111, 33, 10, 0};
static uint32_t arr_utf32[8] = (uint32_t [8]){72, 101, 108, 108, 111, 33, 10, 0};

static uint8_t xxx[8] = (uint8_t [8]){};

int main(void)
{

    utf32_putchar(ratUTF32);
    utf32_putchar(0xA);

    utf16_puts((uint16_t *)u"Hello Ω!\n");
    utf32_puts((uint32_t *)U"Hello 🐀!\n");
    //0x1F400
    // 0001.1111.0100.0000.0000
    //printf("%C", '\x1F400')
    return 0;
}

