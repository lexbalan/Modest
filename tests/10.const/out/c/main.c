// tests/10.const/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include "./minmax.h"



#define CARR  {0, 10, 15, 20, 25, 30}

struct Point {
	double x;
	double y;
};
typedef struct Point Point;

struct Line {
	Point a;
	Point b;
};
typedef struct Line Line;

#define ZERO  0
#define POINT_ZERO  {.x = ZERO, .y = ZERO}
#define POINT_ONE  {.x = 1.0, .y = 1.0}

#define LINE0  { \
	.a = POINT_ZERO, \
	.b = POINT_ONE \
}

#define LINE1  { \
	.a = {.x = 10, .y = 20}, \
	.b = {.x = 30, .y = 40} \
}

#define LINE2  { \
	.a = POINT_ZERO, \
	.b = POINT_ONE \
}

#define LINE3  { \
	.a = {.x = 10, .y = 20}, \
	.b = {.x = 30, .y = 40} \
}

#define LINES  {LINE0, LINE1, LINE2, LINE3}

struct WrappedArray {
	//array: [10]Int32
	int32_t x;
};
typedef struct WrappedArray WrappedArray;

#define WA  {0}

// Pythagorean theorem
static float distance(Point a, Point b) {
	const double dx = minmax_max_float64(a.x, b.x) - minmax_min_float64(a.x, b.x);
	const double dy = minmax_max_float64(a.y, b.y) - minmax_min_float64(a.y, b.y);
	const double dx2 = pow(dx, 2.000000);
	const double dy2 = pow(dy, 2.000000);
	return sqrt(dx2 + dy2);
}


static float lineLength(Line line) {
	return distance(line.a, line.b);
}


int main(void) {
	const float lines_0_len = lineLength(((const Line[4])LINES)[0]);
	const float lines_1_len = lineLength(((const Line[4])LINES)[1]);
	const float lines_2_len = lineLength(((const Line[4])LINES)[2]);
	const float lines_3_len = lineLength(((const Line[4])LINES)[3]);

	printf("lines_0_len = %f\n", lines_0_len);
	printf("lines_1_len = %f\n", lines_1_len);
	printf("lines_2_len = %f\n", lines_2_len);
	printf("lines_3_len = %f\n", lines_3_len);

	//	let y = wa.x

	//	var i: Nat32 = 0
	//	while i < 10 {
	//		let x = wa.array[i]
	//		printf("x[%d]=%d\n", i, x)
	//		++i
	//	}

	return 0;
}


