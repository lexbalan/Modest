// examples/14.records/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




typedef struct {
    uint32_t x;
    uint32_t y;
} Point2D;

int main()
{
    printf("records test\n");

    // compare two Point2D records
    Point2D p2d0;
    p2d0 = (Point2D){.x = 1, .y = 2};
    Point2D p2d1;
    p2d1 = (Point2D){.x = 10, .y = 20};

    if (memcmp(&p2d0, &p2d1, sizeof p2d0) == 0) {
        printf("p2d0 == p2d1\n");
    } else {
        printf("p2d0 != p2d1\n");
    }


    // compare Point2D with anonymous record

    Point2D p2d2;
    p2d2 = p2d0;
    struct {        uint32_t x;        uint32_t y;
    } p2d3;
    p2d3 = (struct {        uint32_t x;        uint32_t y;
    }){.x = 1, .y = 2};

    if (memcmp(&p2d2, &*(Point2D *)&p2d3, sizeof p2d2) == 0) {
        printf("p2d2 == p2d3\n");
    } else {
        printf("p2d2 != p2d3\n");
    }



    return 0;
}

