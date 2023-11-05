
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
    char ch8;
    uint16_t ch16;
    uint32_t ch32;

    ch8 = '\x1f400';
    ch16 = u'\x1f400';
    ch32 = U'\x1f400';

    printf("ch8 == %x\n", ch8);
    printf("ch16 == %x\n", ch16);
    printf("ch32 == %x\n", ch32);

    printf("Hello World!\n");
    return 0;
}

