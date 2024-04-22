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

    int64_t a;
    int64_t b;
    int64_t sum;
    asm("add %0, %1, %2");

    return 0;
}

