
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/arr_param/main.cm


struct __x {int32_t x[2];};
struct __retval {int32_t value[2];};
struct __retval swap(struct __x x)
{
    int32_t out[2];
    out[0] = x[1];
    out[1] = x[0];
    return out;
}

int main(void)
{
    printf("hello world!\n");
    return 0;
}

