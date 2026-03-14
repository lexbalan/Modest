
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include "./minmax.h"
#define CARR {0, 10, 15} + {20, 25, 30}
struct point {
	double x;
	double y;
};
struct line {
	struct point a;
	struct point b;
};
#define ZERO 0
#define POINT_ZERO (struct point){.x = ZERO, .y = ZERO}
#define POINT_ONE (struct point){.x = 1.0, .y = 1.0}
#define LINE0 (struct line){ \
	.a = POINT_ZERO, \
	.b = POINT_ONE \
}
#define LINE1 (struct line){ \
	.a = {.x = 10, .y = 20}, \
	.b = {.x = 30, .y = 40} \
}
#define LINE2 (struct line){ \
	.a = POINT_ZERO, \
	.b = POINT_ONE \
}
#define LINE3 (struct line){ \
	.a = {.x = 10, .y = 20}, \
	.b = {.x = 30, .y = 40} \
}
#define LINES {LINE0, LINE1, LINE2, LINE3}
struct wrapped_array {
	int32_t x;
};
#define WA (struct wrapped_array){0}

static float distance(struct point a, struct point b) {
	const double dx = minmax_max_float64(a.x, b.x) - minmax_min_float64(a.x, b.x);
	const double dy = minmax_max_float64(a.y, b.y) - minmax_min_float64(a.y, b.y);
	const double dx2 = pow(dx, 2.0);
	const double dy2 = pow(dy, 2.0);
	return sqrt(dx2 + dy2);
}

static float lineLength(struct line line) {
	return distance(line.a, line.b);
}

int main(void) {
	const float lines_0_len = lineLength(((const struct line [4])LINES)[0]);
	const float lines_1_len = lineLength(((const struct line [4])LINES)[1]);
	const float lines_2_len = lineLength(((const struct line [4])LINES)[2]);
	const float lines_3_len = lineLength(((const struct line [4])LINES)[3]);
	printf("lines_0_len = %f\n", lines_0_len);
	printf("lines_1_len = %f\n", lines_1_len);
	printf("lines_2_len = %f\n", lines_2_len);
	printf("lines_3_len = %f\n", lines_3_len);
	return 0;
}
