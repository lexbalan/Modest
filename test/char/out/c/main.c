// test/char/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int main()
{
    printf("test/char\n");

    char ch08;
    uint16_t ch16;
    uint32_t ch32;

    ch08 = 's';
    ch16 = u'Я';
    ch32 = U'🐀';

    //printf("ch08 = 0x%x (%c)\n", ch08 to Nat32, ch08)
    //printf("ch16 = 0x%x (%c)\n", ch16 to Nat32, ch16)
    //printf("ch32 = 0x%x (%c)\n", ch32 to Nat32, ch32)

    return 0;
}

