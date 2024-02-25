// test/char/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




#define UTF8_CHAR  ('s')
#define UTF16_CHAR  (u'Я')
#define UTF32_CHAR  (U'🐀')

int main()
{
    char ch08;
    uint16_t ch16;
    uint32_t ch32;

    ch08 = 's';

    //ch08 = "Я"[0]  // error
    ch16 = u'Я';

    //ch08 = "🐀"[0]  // error
    //ch16 = "🐀"[0]  // error
    ch32 = U'🐀';

    //printf("ch08 = 0x%x (%c)\n", ch08 to Nat32, ch08)
    //printf("ch16 = 0x%x (%c)\n", ch16 to Nat32, ch16)
    //printf("ch32 = 0x%x (%c)\n", ch32 to Nat32, ch32)

    printf("%s\n", "Hello World!");

    return 0;
}

