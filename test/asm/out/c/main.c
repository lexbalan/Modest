// test/asm/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




uint64_t sum64(uint64_t a, uint64_t b)
{
    return a + b;
}

int main()
{
    printf("asm test");

    asm("nop");

    return 0;
}

