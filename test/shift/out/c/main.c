// examples/1.hello_world/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>





int main()
{
    printf("test shift\n");

    int32_t c;

    c = 1 << 31;
    printf("1 << 31 = 0x%x\n", c);

    c = 0x80000000 >> 31;
    printf("0x80000000 >> 31 = 0x%x\n", c);

    return 0;
}

