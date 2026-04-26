
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
	const int dx = abs(a.x - b.x);
	const int dy = abs(a.y - b.y);
	printf("dx = %d\n", dx);
	printf("dy = %d\n", dy);
	return (float)dy / (float)dx;
}

int main(void) {
	printf("float test\n");
	printf("2 = %d\n", 2);
	printf("2/3 = %f\n", (double)(2.0 / 3));
	#define r 10
	const double s = main_squareOfCircle(r);
	printf("s = %f\n", s);
	#define k (1.0 / 8)
	printf("k = %f\n", (double)k);
	printf("sizeof(Float32) = %zu\n", sizeof(float));
	printf("sizeof(Float64) = %zu\n", sizeof(double));
	const float sl = main_slope((struct main_point2_d){.x = 10, .y = 20}, (struct main_point2_d){.x = 30, .y = 50});
	printf("slope = %f\n", (double)sl);
	return 0;
	#undef r
	#undef k
}

