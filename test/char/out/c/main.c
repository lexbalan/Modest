
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm

#define hello  "Hello"
#define world  " World!\n"

#define hello_world  hello  world


int main(void)
{
    char ch08;
    uint16_t ch16;
    uint32_t ch32;

    //ch08 := "🐀"[0]  // error
    //ch16 := "🐀"[0]  // error
    ch32 = U'\x1f400';

    ch08 = 's';
    ch16 = u'\x410';
    ch32 = U'\x42f';

    printf("ch08 == 0x%x (%c)\n", ch08, ch08);
    printf("ch16 == 0x%x (%c)\n", ch16, ch16);
    printf("ch32 == 0x%x (%c)\n", ch32, ch32);

    printf("Hello World!\n");

    return 0;
}

