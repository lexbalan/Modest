
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

// test/10.const/main.cm



typedef struct {
    double x;
    double y;
} Point;

typedef struct {
    Point a;
    Point b;
} Line;

#define zero  0
#define pointZero  (Point){.x = zero, .y = zero}
#define pointOne  (Point){.x = 1.0, .y = 1.0}

#define line0  (Line){ \
    .a = pointZero, \
    .b = pointOne \
}

#define carr  (uint8_t [5]){0, 10, 15, 20, 25}

#define line1  (Line){ \
    .a = (Point){.x = carr[1], .y = carr[2]}, \
    .b = (Point){.x = carr[3], .y = carr[4]} \
}

#define lines  (Line [2]){line0, line1}


// Pythagorean theorem
float distance(Point a, Point b)
{
    const double dx = max_float64(a.x, b.x) - min_float64(a.x, b.x);
    const double dy = max_float64(a.y, b.y) - min_float64(a.y, b.y);
    const double dx2 = pow((double)dx, 2);
    const double dy2 = pow((double)dy, 2);
    return sqrt((double)dx2 + dy2);
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

