
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm

int main(void)
{
    const uint32_t c32 = U'\x1f389';

    uint32_t c;

    c = (uint32_t)c32;


    printf("Hello World! 🎉\n");
    return 0;
}

