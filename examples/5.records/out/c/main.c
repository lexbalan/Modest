
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>




struct point {
	float x;
	float y;
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
static float distance(struct point a, struct point b) {
	const float dx = max(a.x, b.x) - min(a.x, b.x);
	const float dy = max(a.y, b.y) - min(a.y, b.y);
	const double dx2 = pow(dx, 2.0);
	const double dy2 = pow(dy, 2.0);
	return sqrt(dx2 + dy2);
}


static float lineLength(struct line line) {
	return distance(line.a, line.b);
}


static void ptr_example(void) {
	struct point *const ptr_p = (struct point *)malloc(sizeof(struct point));
	ptr_p->x = 10.0;
	ptr_p->y = 20.0;

	printf("point(%f, %f)\n", ptr_p->x, ptr_p->y);
}


int main(void) {
	const float len = lineLength(line);
	printf("line length = %f\n", len);

	ptr_example();

	return 0;
}


