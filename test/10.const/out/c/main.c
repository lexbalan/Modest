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

Point pointZero = {.x = 0.0, .y = 0.0};

Point pointOne = {.x = 1.0, .y = 1.0};


Line line0 = {
    .a = {.x = 0.0, .y = 0.0},
    .b = {.x = 1.0, .y = 1.0}
};




Line line1 = {
    .a = {.x = 10.0, .y = 15.0},
    .b = {.x = 20.0, .y = 25.0}
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
        .a = (Point){.x = 0.0, .y = 0.0},
        .b = (Point){.x = 1.0, .y = 1.0}});
    const float lines_1_len = lineLength((Line){
        .a = (Point){.x = 10.0, .y = 15.0},
        .b = (Point){.x = 20.0, .y = 25.0}});

    printf("lines_0_len = %f\n", lines_0_len);
    printf("lines_1_len = %f\n", lines_1_len);

    return 0;
}

