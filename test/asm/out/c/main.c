// test/asm/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int64_t sum64(int64_t a, int64_t b)
{
    int64_t sum;
    __asm__ volatile (
        "add %0, %1, %2"
        : "=r" (sum)
        : "r" (a), "r" (b)
        : "cc"
    );
    return sum;
}


int main()
{
    printf("asm test");

    int64_t a;
    a = 10;
    int64_t b;
    b = 20;
    int64_t sum;
    sum = sum64(a, b);
    printf("sum(%lld, %lld) = %lld\n", a, b, sum);

    return 0;
}

