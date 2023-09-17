
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/records/main.cm


typedef struct {
    float x;
    float y;
} Point;

typedef struct {
    Point a;
    Point b;
} Line;


static Line line = (Line){
    .a = (Point){.x = 0.0, .y = 0.0},
    .b = (Point){.x = 1.0, .y = 1.0}
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
    float dx = max(a.x, b.x) - min(a.x, b.x);
    float dy = max(a.y, b.y) - min(a.y, b.y);
    double dx2 = pow(dx, 2.0);
    double dy2 = pow(dy, 2.0);
    return sqrt(dx2 + dy2);
}


float lineLength(Line line)
{
    return distance(line.a, line.b);
}


void ptr_example(void)
{
    Point *ptr_p = (Point *)malloc(0);

    // access by pointer
    ptr_p->x = 10.0;
    ptr_p->y = 20.0;

    printf("point(%f, %f)\n", ptr_p->x, ptr_p->y);
}


int main(void)
{
    // by value
    float len = lineLength(line);
    printf("line length = %f\n", len);

    ptr_example();

    return 0;
}

