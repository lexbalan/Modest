// test/cast/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>



int main()
{
    printf("test cast operation\n");

    const int32_t x0 = (int32_t)-1;
    const int64_t x1 = (int64_t)-1;

    const uint64_t y0 = ((uint64_t)(uint32_t)x0);
    const uint64_t y1 = (uint64_t)x1;

    printf("x0 = %llx\n", y0);
    printf("x1 = %llx\n", y1);


    return 0;
}

