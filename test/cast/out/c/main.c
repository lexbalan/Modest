
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm



int main(void)
{
    printf("Hello World!\n");

/*let x0 = -1 to Nat32
    let x1 = -1 to Nat64

    let y0 = x0 to Nat64
    let y1 = x1 to Nat64

    printf("x0 = %llx\n", y0)
    printf("x1 = %llx\n", y1)*/

    const int32_t x0 = (const int32_t)-1;
    const int64_t x1 = (const int64_t)-1;

    const uint64_t y0 = ((const uint64_t)(uint32_t)x0);
    const uint64_t y1 = (const uint64_t)x1;

    printf("x0 = %llx\n", y0);
    printf("x1 = %llx\n", y1);


    return 0;
}

