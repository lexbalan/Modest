
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include "./minmax.h"
#define MAIN_CARR ({0, 10, 15} + {20, 25, 30})
struct main_point {
	double x;
	double y;
};
struct main_line {
	struct main_point a;
	struct main_point b;
};
#define MAIN_ZERO 0
#define MAIN_POINT_ZERO ((struct main_point){.x = MAIN_ZERO, .y = MAIN_ZERO})
#define MAIN_POINT_ONE ((struct main_point){.x = 1.0, .y = 1.0})
#define MAIN_LINE0 ((struct main_line){ \
	.a = MAIN_POINT_ZERO, \
	.b = MAIN_POINT_ONE \
})
#define MAIN_LINE1 ((struct main_line){ \
	.a = {.x = 10, .y = 20}, \
	.b = {.x = 30, .y = 40} \
})
#define MAIN_LINE2 ((struct main_line){ \
	.a = MAIN_POINT_ZERO, \
	.b = MAIN_POINT_ONE \
})
#define MAIN_LINE3 ((struct main_line){ \
	.a = {.x = 10, .y = 20}, \
	.b = {.x = 30, .y = 40} \
})
#define MAIN_LINES {MAIN_LINE0, MAIN_LINE1, MAIN_LINE2, MAIN_LINE3}
struct main_wrapped_array {
	int32_t x;
};
#define MAIN_WA ((struct main_wrapped_array){0})

static float main_distance(struct main_point a, struct main_point b) {
	const double main_dx = minmax_max_float64(a.x, b.x) - minmax_min_float64(a.x, b.x);
	const double main_dy = minmax_max_float64(a.y, b.y) - minmax_min_float64(a.y, b.y);
	const double main_dx2 = pow(main_dx, 2);
	const double main_dy2 = pow(main_dy, 2);
	return sqrt(main_dx2 + main_dy2);
}

static float main_lineLength(struct main_line line) {
	return main_distance(line.a, line.b);
}

int main(void) {
	const float main_lines_0_len = main_lineLength(((const struct main_line [4])MAIN_LINES)[0]);
	const float main_lines_1_len = main_lineLength(((const struct main_line [4])MAIN_LINES)[1]);
	const float main_lines_2_len = main_lineLength(((const struct main_line [4])MAIN_LINES)[2]);
	const float main_lines_3_len = main_lineLength(((const struct main_line [4])MAIN_LINES)[3]);
	printf("lines_0_len = %f\n", main_lines_0_len);
	printf("lines_1_len = %f\n", main_lines_1_len);
	printf("lines_2_len = %f\n", main_lines_2_len);
	printf("lines_3_len = %f\n", main_lines_3_len);
	return 0;
}

