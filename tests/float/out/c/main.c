// tests/float/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>



#define MATH_PI  3.141592653589793238462643383279502884

static double squareOfCircle(double radius) {
	return pow(radius, 2.000000) * MATH_PI;
}


struct Point2D {
	int x;
	int y;
};
typedef struct Point2D Point2D;

static float slope(Point2D a, Point2D b) {
	const int dx = abs(a.x - b.x);
	const int dy = abs(a.y - b.y);
	printf("dx = %d\n", dx);
	printf("dy = %d\n", dy);
	return (float)dy / (float)dx;
}


int main(void) {
	printf("float test\n");

	printf("2 = %d\n", 2);
	printf("2/3 = %f\n", (double)(2.0 / 3.000000));

	#define r  10
	const double s = squareOfCircle(r);
	printf("s = %f\n", s);

	#define k  (1.0 / 8.000000)
	printf("k = %f\n", (double)k);

	printf("sizeof(Float32) = %zu\n", sizeof(float));
	printf("sizeof(Float64) = %zu\n", sizeof(double));

	// printf %f ожидает получить double а не float!
	const float sl = slope((Point2D){.x = 10, .y = 20}, (Point2D){.x = 30, .y = 50});
	printf("slope = %f\n", (double)sl);

	return 0;

#undef r
#undef k
}


