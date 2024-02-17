// examples/14.records/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
struct __anonymous_struct_3 {uint32_t x; uint32_t y;};
struct __anonymous_struct_4 {uint32_t x; uint32_t y;};




typedef struct {
    uint32_t x;
    uint32_t y;
} Point2D;

typedef struct {
    uint32_t x;
    uint32_t y;
    uint32_t z;
} Point3D;


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
    struct __anonymous_struct_3 p2d3;
    p2d3 = (struct __anonymous_struct_3){.x = 1, .y = 2};

    if (memcmp(&p2d2, &*(Point2D *)&p2d3, sizeof p2d2) == 0) {
        printf("p2d2 == p2d3\n");
    } else {
        printf("p2d2 != p2d3\n");
    }

    struct __anonymous_struct_4 p2d4;
    p2d4 = (struct __anonymous_struct_4){.x = 1, .y = 2};
    if (memcmp(&p2d3, &p2d4, sizeof p2d3) == 0) {
        printf("p2d3 == p2d4\n");
    } else {
        printf("p2d3 != p2d4\n");
    }


    // cons Point3D from Point2D
    // (it is possible if dst record contained all fields from src record
    // and their types are equal)
    Point3D p3d;
    p3d = *(Point3D *)&p2d2;


    return 0;
}

