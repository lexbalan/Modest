
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// test/cast/main.cm



int main(void)
{
    printf("test cast operation\n");

    const int32_t x0 = (const int32_t)-1;
    const int64_t x1 = (const int64_t)-1;

    const uint64_t y0 = ((const uint64_t)(uint32_t)x0);
    const uint64_t y1 = (const uint64_t)x1;

    printf("x0 = %llx\n", y0);
    printf("x1 = %llx\n", y1);


    return 0;
}

