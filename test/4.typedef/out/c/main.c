// test/4.typedef/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>



typedef int32_t NewInt32;

int main()
{
    printf("test typedef\n");

    NewInt32 newInt32;
    newInt32 = 0;

    return 0;
}

