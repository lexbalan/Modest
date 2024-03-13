// test/tag/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>



//@feature("unsafe")


typedef struct {
    int32_t x;
    int32_t y;
} Point;

int main()
{
    printf("tag test");

    int32_t *const p = 0;
    printf("*p = %i\n", *p);

    int32_t a;

    int32_t arr[10];
    memcpy(&arr, &(int32_t[10]){0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 40);

    Point p0;
    p0 = (Point){};

    //var s : Tag = #justSymbol

    return 0;
}

