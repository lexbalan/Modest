
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>



struct Point {
	float x;
	float y;
};
typedef struct Point Point;

struct Line {
	Point a;
	Point b;
};
typedef struct Line Line;

static Line line = {
	.a = {.x = 0, .y = 0},
	.b = {.x = 1.0, .y = 1.0}
};

__attribute__((always_inline))
static inline float max(float a, float b) {
	if (a > b) {
		return a;
	}
	return b;
}


__attribute__((always_inline))
static inline float min(float a, float b) {
	if (a < b) {
		return a;
	}
	return b;
}



// Pythagorean theorem
static float distance(Point a, Point b) {
	const float dx = max(a.x, b.x) - min(a.x, b.x);
	const float dy = max(a.y, b.y) - min(a.y, b.y);
	const double dx2 = pow(dx, 2.000000);
	const double dy2 = pow(dy, 2.000000);
	return sqrt(dx2 + dy2);
}


static float lineLength(Line line) {
	return distance(line.a, line.b);
}


static void ptr_example(void) {
	Point *const ptr_p = (Point *)malloc(sizeof(Point));

	// access by pointer
	ptr_p->x = 10.000000;
	ptr_p->y = 20.000000;

	printf("point(%f, %f)\n", ptr_p->x, ptr_p->y);
}


int main(void) {
	// by value
	const float len = lineLength(line);
	printf("line length = %f\n", len);

	ptr_example();

	return 0;
}


