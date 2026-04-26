
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
struct main_point {
	float x;
	float y;
};
struct main_line {
	struct main_point a;
	struct main_point b;
};
static struct main_line main_line = (struct main_line){
	.a = {.x = 0, .y = 0},
	.b = {.x = 1.0, .y = 1.0}
};

__attribute__((always_inline))
static inline float main_max(float a, float b) {
	if (a > b) {
		return a;
	}
	return b;
}

__attribute__((always_inline))
static inline float main_min(float a, float b) {
	if (a < b) {
		return a;
	}
	return b;
}

static float main_distance(struct main_point a, struct main_point b) {
	const float dx = main_max(a.x, b.x) - main_min(a.x, b.x);
	const float dy = main_max(a.y, b.y) - main_min(a.y, b.y);
	const double dx2 = pow(dx, 2);
	const double dy2 = pow(dy, 2);
	return sqrt(dx2 + dy2);
}

static float main_lineLength(struct main_line line) {
	return main_distance(line.a, line.b);
}

static void main_ptr_example(void) {
	struct main_point *const ptr_p = (struct main_point *)malloc(sizeof(struct main_point));
	ptr_p->x = 10;
	ptr_p->y = 20;
	printf("point(%f, %f)\n", ptr_p->x, ptr_p->y);
}

int main(void) {
	const float len = main_lineLength(main_line);
	printf("line length = %f\n", len);
	main_ptr_example();
	return 0;
}

