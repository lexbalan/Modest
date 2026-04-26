
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define MAIN_MATH_PI 3.141592653589793238462643383279502884

static double main_squareOfCircle(double radius) {
	return pow(radius, 2) * MAIN_MATH_PI;
}
struct main_point2_d {
	int x;
	int y;
};

static float main_slope(struct main_point2_d a, struct main_point2_d b) {
	const int main_dx = abs(a.x - b.x);
	const int main_dy = abs(a.y - b.y);
	printf("dx = %d\n", main_dx);
	printf("dy = %d\n", main_dy);
	return (float)main_dy / (float)main_dx;
}

int main(void) {
	printf("float test\n");
	printf("2 = %d\n", 2);
	printf("2/3 = %f\n", (double)(2.0 / 3));
	#define main_r 10
	const double main_s = main_squareOfCircle(main_r);
	printf("s = %f\n", main_s);
	#define main_k (1.0 / 8)
	printf("k = %f\n", (double)main_k);
	printf("sizeof(Float32) = %zu\n", sizeof(float));
	printf("sizeof(Float64) = %zu\n", sizeof(double));
	const float main_sl = main_slope((struct main_point2_d){.x = 10, .y = 20}, (struct main_point2_d){.x = 30, .y = 50});
	printf("slope = %f\n", (double)main_sl);
	return 0;
	#undef main_r
	#undef main_k
}

