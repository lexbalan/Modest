// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define _carr  {0, 10, 15, 20, 25, 30}
int8_t carr[6] = _carr;


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

#define zero  0
#define pointZero  {.x = zero, .y = zero}
#define pointOne  {.x = 1.0, .y = 1.0}

#define line0  { \
	.a = pointZero, \
	.b = pointOne \
}

#define line1  { \
	.a = {.x = 10, .y = 20}, \
	.b = {.x = 30, .y = 40} \
}

#define line2  { \
	.a = pointZero, \
	.b = pointOne \
}

#define line3  { \
	.a = {.x = 10, .y = 20}, \
	.b = {.x = 30, .y = 40} \
}

#define _lines  {line0, line1, line2, line3}
Line lines[4] = _lines;


struct WrappedArray {
	//array: [10]Int32
	int32_t x;
};
typedef struct WrappedArray WrappedArray;

#define wa  {}
// Pythagorean theorem
static float distance(Point a, Point b)
{
	const double dx = minmax_max_float64(a.x, b.x) - minmax_min_float64(a.x, b.x);
	const double dy = minmax_max_float64(a.y, b.y) - minmax_min_float64(a.y, b.y);
	const double dx2 = pow(dx, (double)(2));
	const double dy2 = pow(dy, (double)(2));
	return sqrt(dx2 + dy2);
}


static float lineLength(Line line)
{
	return distance(line.a, line.b);
}


int main()
{
	const float lines_0_len = lineLength(lines[0]);
	const float lines_1_len = lineLength(lines[1]);
	const float lines_2_len = lineLength(lines[2]);
	const float lines_3_len = lineLength(lines[3]);

	printf("lines_0_len = %f\n", lines_0_len);
	printf("lines_1_len = %f\n", lines_1_len);

	//	let y = wa.x

	//	var i = 0
	//	while i < 10 {
	//		let x = wa.array[i]
	//		printf("x[%d]=%d\n", i, x)
	//		++i
	//	}

	return 0;
}

