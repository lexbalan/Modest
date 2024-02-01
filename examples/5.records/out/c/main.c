// examples/5.records/main.cm

#include <stdint.h>
#include <string.h>
#include <stdbool.h>

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>


typedef struct {
    float x;
    float y;
} Point;

typedef struct {
    Point a;
    Point b;
} Line;


static Line line = {
    .a = {.x = 0, .y = 0},
    .b = {.x = 1.0, .y = 1.0}
};


static inline float max(float a, float b)
{
    if (a > b) {
        return a;
    }
    return b;
}

static inline float min(float a, float b)
{
    if (a < b) {
        return a;
    }
    return b;
}


// Pythagorean theorem
float distance(Point a, Point b)
{
    const float dx = max(a.x, b.x) - min(a.x, b.x);
    const float dy = max(a.y, b.y) - min(a.y, b.y);
    const double dx2 = pow(dx, 2);
    const double dy2 = pow(dy, 2);
    return sqrt(dx2 + dy2);
}


float lineLength(Line line)
{
    return distance(line.a, line.b);
}


void ptr_example()
{
    Point *const ptr_p = (Point *)malloc(sizeof(Point));

    // access by pointer
    ptr_p->x = 10;
    ptr_p->y = 20;

    printf("point(%f, %f)\n", ptr_p->x, ptr_p->y);
}


int main()
{
    // by value
    const float len = lineLength(line);
    printf("line length = %f\n", len);

    ptr_example();

    return 0;
}

