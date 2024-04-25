// test/asm/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int64_t sumsub64(int64_t a, int64_t b)
{
    printf("sumsub64(%lld, %lld)\n", a, b);

    int64_t sum;
    int64_t sub;
    __asm__ volatile (
        "add %0, %2, %3\nsub %1, %2, %3\n"
        : "=r" (sum), "=r" (sub)
        : "r" (a), "r" (b)
        : "cc"
    );

    printf("sumsub64 sum = %lld\n", sum);
    printf("sumsub64 sub = %lld\n", sub);

    return sum + sub;
}


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

int64_t sub64(int64_t a, int64_t b)
{
    int64_t sub;
    __asm__ volatile (
        "sub %0, %1, %2"
        : "=r" (sub)
        : "r" (a), "r" (b)
        : "cc"
    );
    return sub;
}


int main()
{
    printf("inline asm test\n");

    int64_t a;
    a = 10;
    int64_t b;
    b = 20;

    const int64_t sum = sum64(a, b);
    const int64_t sub = sub64(a, b);

    printf("sum(%lld, %lld) = %lld\n", a, b, sum);
    printf("sub(%lld, %lld) = %lld\n", a, b, sub);

    const int64_t sumsub = sumsub64(a, b);
    printf("sumsub64(%lld, %lld) = %lld\n", a, b, sumsub);

    return 0;
}

