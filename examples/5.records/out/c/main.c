
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
struct point {
	double x;
	double y;
};
struct line {
	struct point a;
	struct point b;
};
static struct line line = (struct line){
	.a = {.x = 0, .y = 0},
	.b = {.x = 1.0, .y = 1.0}
};

__attribute__((always_inline))
static inline double max(double a, double b) {
	if (a > b) {
		return a;
	}
	return b;
}

__attribute__((always_inline))
static inline double min(double a, double b) {
	if (a < b) {
		return a;
	}
	return b;
}

static double distance(struct point a, struct point b) {
	const double dx = max(a.x, b.x) - min(a.x, b.x);
	const double dy = max(a.y, b.y) - min(a.y, b.y);
	const double dx2 = pow(dx, 2.0);
	const double dy2 = pow(dy, 2.0);
	return sqrt(dx2 + dy2);
}

static double lineLength(struct line line) {
	return distance(line.a, line.b);
}

static void ptr_example(void) {
	struct point *const ptr_p = (struct point *)malloc(sizeof(struct point));
	ptr_p->x = 1.0e+01;
	ptr_p->y = 2.0e+01;
	printf("point(%f, %f)\n", ptr_p->x, ptr_p->y);
}

int main(void) {
	const double len = lineLength(line);
	printf("line length = %f\n", len);
	ptr_example();
	return 0;
}

