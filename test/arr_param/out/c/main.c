
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/arr_param/main.cm


struct swap_x {int32_t a[2];};
struct swap_retval {int32_t a[2];};
struct swap_retval swap(struct swap_x x)
{
    int32_t out[2];
    out[0] = x.a[1];
    out[1] = x.a[0];
    return *(struct swap_retval *)&out;
}

int main(void)
{
    int32_t a[2];
    a[0] = 10;
    a[1] = 20;

    const struct swap_retval b = swap((struct swap_x)a);

    printf("b[0] = %i\n", b.a[0]);
    printf("b[1] = %i\n", b.a[1]);

    printf("hello world!\n");
    return 0;
}

