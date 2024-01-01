
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/arr_param/main.cm


struct swap_x {int32_t x[2];};
struct swap_retval {int32_t value[2];};
struct swap_retval swap(struct swap_x x)
{
    int32_t out[2];
    out[0] = x.x[1];
    out[1] = x.x[0];
    return *(struct swap_retval *)&out;
}

int main(void)
{
    printf("hello world!\n");
    return 0;
}

