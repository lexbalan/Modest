// test/10.const/main.cm

#include <string.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include "./minmax.h"
#include <stdint.h>
#include <stdbool.h>





typedef struct {
    double x;
    double y;
} Point;

typedef struct {
    Point a;
    Point b;
} Line;

#define zero  0
#define pointZero  {.x = zero, .y = zero}
#define pointOne  {.x = 1.0, .y = 1.0}

#define line0  { \
    .a = pointZero, \
    .b = pointOne \
}


int8_t carr[5] = {0, 10, 15, 20, 25};

#define line1  { \
    .a = {.x = carr[1], .y = carr[2]}, \
    .b = {.x = carr[3], .y = carr[4]} \
}


Line lines[2] = {{
        .a = {.x = 0.0, .y = 0.0},
        .b = {.x = 1.0, .y = 1.0}
    }, {
        .a = {.x = 10.0, .y = 15.0},
        .b = {.x = 20.0, .y = 25.0}
    }};


// Pythagorean theorem
float distance(Point a, Point b)
{
    const double dx = max_float64(a.x, b.x) - min_float64(a.x, b.x);
    const double dy = max_float64(a.y, b.y) - min_float64(a.y, b.y);
    const double dx2 = pow((double)dx, 2);
    const double dy2 = pow((double)dy, 2);
    return sqrt((double)(dx2 + dy2));
}


float lineLength(Line line)
{
    return distance(line.a, line.b);
}


int main(void)
{
    const float lines_0_len = lineLength(lines[0]);
    const float lines_1_len = lineLength(lines[1]);

    printf("lines_0_len = %f\n", lines_0_len);
    printf("lines_1_len = %f\n", lines_1_len);

    return 0;
}

