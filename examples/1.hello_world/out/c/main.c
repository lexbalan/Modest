
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm
#include <wchar.h>
typedef int16_t WChar;

typedef uint16_t * WCharStr16;



// декодирует символ UTF-32 в последовательность UTF-8
void utf32_to_utf8(uint32_t x, uint8_t *buf)
{
    if (x <= 0x0000007F) {
        buf[0] = (uint8_t)x;
        buf[1] = 0;
    } else if (x <= 0x000007FF) {
        const uint32_t a = x >> 6 & 0x1F;
        const uint32_t b = x >> 0 & 0x3F;
        buf[0] = 0xC0 | (uint8_t)a;
        buf[1] = 0x80 | (uint8_t)b;
        buf[2] = 0;
    } else if (x <= 0x0000FFFF) {
        const uint32_t a = x >> 12 & 0x0F;
        const uint32_t b = x >> 6 & 0x3F;
        const uint32_t c = x >> 0 & 0x3F;
        buf[0] = 0xE0 | (uint8_t)a;
        buf[1] = 0x80 | (uint8_t)b;
        buf[2] = 0x80 | (uint8_t)c;
        buf[3] = 0;
    } else if (x <= 0x0010FFFF) {
        const uint32_t a = x >> 18 & 0x07;
        const uint32_t b = x >> 12 & 0x3F;
        const uint32_t c = x >> 6 & 0x3F;
        const uint32_t d = x >> 0 & 0x3F;
        buf[0] = 0xF0 | (uint8_t)a;
        buf[1] = 0x80 | (uint8_t)b;
        buf[2] = 0x80 | (uint8_t)c;
        buf[3] = 0x80 | (uint8_t)d;
        buf[4] = 0;
    }
}


void utf32_putchar(uint32_t c)
{
    uint8_t decoded_buf[5];
    utf32_to_utf8(c, &decoded_buf[0]);

    int i = 0;
    while (true) {
        const uint8_t c = decoded_buf[i];
        if (c == 0) {break;}
        putchar((int32_t)c);
        i = i + 1;
    }
}


void utf32_puts(uint32_t *s)
{
    int i = 0;
    while (true) {
        const uint32_t c = s[i];
        if (c == 0) {break;}
        utf32_putchar(c);
        i = i + 1;
    }
}


void utf16_puts(uint16_t *s)
{
    int i = 0;
    while (true) {
        const uint16_t c = s[i];
        if (c == 0) {break;}
        utf32_putchar((uint32_t)c);
        i = i + 1;
    }
}


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

int main(void)
{
/* var buf : [32]Nat8

    utf32_to_utf8(0x1F400, &buf to Pointer)

    var i := 0
    while i < 5 {
        printf("%d : %x\n", i, buf[i])
        i := i + 1
    }*/

    //printf("%s\n", &buf to Pointer)

    //sprintf(&buf to Pointer, "Hello 🐀\n")

/*var i := 0
    while i < 20 {
        //f0 9f 90 80
        printf("%02d %x\n", i, buf[i])
        i := i + 1
    }*/

    //printf("Hello 🐀\n")

/*
    putchar(ratUTF8[0])
    putchar(ratUTF8[1])
    putchar(ratUTF8[2])
    putchar(ratUTF8[3])
    putchar(0x0A)
    //*/


    putwchar(0x03A9);

    utf32_putchar(ratUTF32);
    utf32_putchar(0xA);

    utf16_puts((uint16_t *)u"Hello Ω!\n");
    utf32_puts((uint32_t *)U"Hello 🐀!\n");
    //0x1F400
    // 0001.1111.0100.0000.0000
    //printf("%C", '\x1F400')
    return 0;
}

