
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/arr_param/main.cm


struct swap_x {int32_t a[2];};
struct swap_retval {int32_t a[2];};
struct swap_retval swap(struct swap_x x);


struct swap_retval swap(struct swap_x x)
{
    int32_t out[2];
    out[0] = x.a[1];
    out[1] = x.a[0];
    return *(struct swap_retval *)&out;
}


int32_t global_array[2] = {1, 2};

int main(void)
{
    int32_t local_array[2];

    local_array[0] = 10;
    local_array[1] = 20;

    struct swap_retval a = swap(*(struct swap_x *)&local_array);

    printf("a[0] = %i\n", a.a[0]);
    printf("a[1] = %i\n", a.a[1]);

    struct swap_retval b = swap(*(struct swap_x *)&global_array);

    printf("b[0] = %i\n", b.a[0]);
    printf("b[1] = %i\n", b.a[1]);

    printf("hello world!\n");

    return 0;
}

