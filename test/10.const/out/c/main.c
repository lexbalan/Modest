// test/10.const/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <math.h>
#include "./minmax.h"

typedef struct Point Point;
typedef struct Line Line;






struct Point {
	double x;
	double y;
};

struct Line {
	Point a;
	Point b;
};

#define zero  0
#define pointZero  {.x = zero, .y = zero}
#define pointOne  {.x = 1.0, .y = 1.0}

#define line0  { \
	.a = pointZero, \
	.b = pointOne \
}

#define _carr  {0, 10, 15, 20, 25, 30}
const int8_t carr[6] = _carr;

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
const Line lines[4] = _lines;


// Pythagorean theorem
float distance(Point a, Point b)
{
	const double dx = max_float64(a.x, b.x) - min_float64(a.x, b.x);
	const double dy = max_float64(a.y, b.y) - min_float64(a.y, b.y);
	const double dx2 = pow(dx, (double)(2));
	const double dy2 = pow(dy, (double)(2));
	return sqrt(dx2 + dy2);
}


float lineLength(Line line)
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

	return 0;
}

