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

const Point pointZero = {.x = 0, .y = 0};

const Point pointOne = {.x = 1.0, .y = 1.0};


const Line line0 = {
    .a = {.x = 0, .y = 0},
    .b = {.x = 1.0, .y = 1.0}
};


const int8_t carr[7] = {0, 10, 15, 20, 25, 30};


const Line line1 = {
    .a = {.x = 10, .y = 15},
    .b = {.x = 20, .y = 25}
};


const Line lines[2] = {{
        .a = {.x = 0, .y = 0},
        .b = {.x = 1.0, .y = 1.0}
    }, {
        .a = {.x = 10, .y = 15},
        .b = {.x = 20, .y = 25}
    }};


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
        .a = (Point){.x = 0, .y = 0},
        .b = (Point){.x = 1.0, .y = 1.0}});
    const float lines_1_len = lineLength((Line){
        .a = (Point){.x = 10, .y = 15},
        .b = (Point){.x = 20, .y = 25}});

    printf("lines_0_len = %f\n", lines_0_len);
    printf("lines_1_len = %f\n", lines_1_len);

    return 0;
}

