
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/1.hello_world/main.m


typedef struct {
    int32_t x[2 * 20];
} RecordWith2DArray;


RecordWith2DArray yy(void)
{
    RecordWith2DArray s = (RecordWith2DArray){
        .x = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    };
    return s;
}


struct inc_items_x {int32_t a[2 * 20];};
struct inc_items_retval {int32_t a[2 * 20];};
struct inc_items_retval inc_items(struct inc_items_x x)
{
    int32_t x0[2 * 20];
    *(struct inc_items_x *)&x0 = x;
    int32_t retval[2 * 20];

    int i = 0;
    while (i < 20) {
        retval[0 * 20 + i] = x0[0 * 20 + i] + 1;
        i = i + 1;
    }

    i = 0;
    while (i < 20) {
        retval[1 * 20 + i] = x0[1 * 20 + i] + 1;
        i = i + 1;
    }

    return *(struct inc_items_retval *)&retval;
}


int main(void)
{
    const RecordWith2DArray rec_with_2d_array = yy();
    int32_t array_2d[2 * 20];
    memcpy(&array_2d, &rec_with_2d_array.x, sizeof array_2d);

    int32_t w[2 * 20];
    *(struct inc_items_retval *)&w = inc_items(*(struct inc_items_x *)&array_2d);

    int i = 0;
    while (i < 10) {
        printf("y[0][%i] = %i\n", i, w[0 * 20 + i]);
        printf("y[1][%i] = %i\n", i, w[1 * 20 + i]);
        i = i + 1;
    }


    char x[2 * 10];
    memcpy(&x[0 * 10], &(char [10]){'h', 'e', 'l', 'l', 'o', '\0', '\0', '\0', '\0', '\0'}, 10);
    memcpy(&x[1 * 10], &(char [10]){'w', 'o', 'r', 'l', 'd', '\0', '\0', '\0', '\0', '\0'}, 10);
    //let z = x
    //ee(z)

    return 0;
}

