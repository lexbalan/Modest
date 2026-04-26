
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
	const float main_dx = main_max(a.x, b.x) - main_min(a.x, b.x);
	const float main_dy = main_max(a.y, b.y) - main_min(a.y, b.y);
	const double main_dx2 = pow(main_dx, 2);
	const double main_dy2 = pow(main_dy, 2);
	return sqrt(main_dx2 + main_dy2);
}

static float main_lineLength(struct main_line line) {
	return main_distance(line.a, line.b);
}

static void main_ptr_example(void) {
	struct main_point *const main_ptr_p = (struct main_point *)malloc(sizeof(struct main_point));
	main_ptr_p->x = 10;
	main_ptr_p->y = 20;
	printf("point(%f, %f)\n", main_ptr_p->x, main_ptr_p->y);
}

int main(void) {
	const float main_len = main_lineLength(main_line);
	printf("line length = %f\n", main_len);
	main_ptr_example();
	return 0;
}

