// test/10.const/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <math.h>
#include "./minmax.h"







typedef struct {
    double x;
    double y;
} Point;

typedef struct {
    Point a;
    Point b;
} Line;

#define zero  0

Point pointZero = {.x = 0.000000, .y = 0.000000};

Point pointOne = {.x = 1.000000, .y = 1.000000};


Line line0 = {
    .a = {.x = 0.000000, .y = 0.000000},
    .b = {.x = 1.000000, .y = 1.000000}
};


Line line1 = {
    .a = {.x = 10.000000, .y = 15.000000},
    .b = {.x = 20.000000, .y = 25.000000}
};


// Pythagorean theorem
float distance(Point a, Point b)
{
    const double dx = max_float64(a.x, b.x) - min_float64(a.x, b.x);
    const double dy = max_float64(a.y, b.y) - min_float64(a.y, b.y);
    const double dx2 = pow(dx, 2);
    const double dy2 = pow(dy, 2);
    return sqrt(dx2 + dy2);
}


float lineLength(Line line)
{
    return distance(line.a, line.b);
}


int main()
{
    const float lines_0_len = lineLength((Line){
        .a = (Point){.x = 0.000000, .y = 0.000000},
        .b = (Point){.x = 1.000000, .y = 1.000000}});
    const float lines_1_len = lineLength((Line){
        .a = (Point){.x = 10.000000, .y = 15.000000},
        .b = (Point){.x = 20.000000, .y = 25.000000}});

    printf("lines_0_len = %f\n", lines_0_len);
    printf("lines_1_len = %f\n", lines_1_len);

    return 0;
}

