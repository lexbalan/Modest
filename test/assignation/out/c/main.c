
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/assignation/main.cm


// Simply record for records assignation test
typedef struct {
    int32_t x;
    int32_t y;
} Point;


int32_t glb_i0 = 0;
int32_t glb_i1 = 321;

Point glb_r0 = (Point){};
Point glb_r1 = (Point){.x = 20, .y = 10};

int32_t glb_a0[10] = {};
int32_t glb_a1[10] = {64, 53, 42};


int main(void)
{
    printf("test assignation\n");

    // -----------------------------------
    // Global

    // copy integers by value
    glb_i0 = glb_i1;
    printf("glb_i0 = %i\n", glb_i0);


    // copy arrays by value
    memcpy(&glb_a0, &glb_a1, sizeof(int32_t [10]));

    printf("glb_a0[0] = %i\n", glb_a0[0]);
    printf("glb_a0[1] = %i\n", glb_a0[1]);
    printf("glb_a0[2] = %i\n", glb_a0[2]);


    // copy records by value
    memcpy(&glb_r0, &glb_r1, sizeof(Point));

    printf("glb_r0.x = %i\n", glb_r0.x);
    printf("glb_r0.y = %i\n", glb_r0.y);


    // -----------------------------------
    // Local

    // copy integers by value
    int32_t loc_i0 = 0;
    int32_t loc_i1 = 123;

    loc_i0 = loc_i1;

    printf("loc_i0 = %i\n", loc_i0);

    // copy arrays by value
    // C backend will be use memcpy()
    int32_t loc_a0[10] = (int32_t [10]){};
    int32_t loc_a1[10] = (int32_t [10]){42, 53, 64};

    memcpy(&loc_a0, &loc_a1, sizeof(int32_t [10]));

    printf("loc_a0[0] = %i\n", loc_a0[0]);
    printf("loc_a0[1] = %i\n", loc_a0[1]);
    printf("loc_a0[2] = %i\n", loc_a0[2]);


    // copy records by value
    // C backend will be use memcpy()
    Point loc_r0 = (Point){};
    Point loc_r1 = (Point){.x = 10, .y = 20};

    memcpy(&loc_r0, &loc_r1, sizeof(Point));

    printf("loc_r0.x = %i\n", loc_r0.x);
    printf("loc_r0.y = %i\n", loc_r0.y);

    return 0;
}

