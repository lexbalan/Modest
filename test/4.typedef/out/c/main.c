
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// test/4.typedef/main.cm

typedef int32_t NewInt32;

int main(void)
{
    printf("test typedef\n");

    NewInt32 newInt32;
    newInt32 = 0;

    return 0;
}

