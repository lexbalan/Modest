// examples/1.hello_world/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>




int main()
{
    printf("bool check\nm");

    uint8_t x;
    bool b;

    x = 1;
    b = (bool)x;
    printf("x = %i\n", (uint32_t)x);
    printf("x to Bool = %i\n", (uint32_t)b);

    x = 2;
    b = (bool)x;
    printf("x = %i\n", (uint32_t)x);
    printf("x to Bool = %i\n", (uint32_t)b);

    x = 3;
    b = (bool)x;
    printf("x = %i\n", (uint32_t)x);
    printf("x to Bool = %i\n", (uint32_t)b);

    return 0;
}

