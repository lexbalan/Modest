// test/10.const/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <math.h>
#include "./minmax.h"







typedef struct {
	double x;
	double y;
} Point;

typedef struct {
	Point a;
	Point b;
} Line;

#define zero  0
#define pointZero  {.x = zero, .y = zero}
#define pointOne  {.x = 1.0, .y = 1.0}

#define line0  { \
	.a = pointZero, \
	.b = pointOne \
}

#define _carr  {0, 10, 15, 20, 25, 30}
int8_t carr[6] = _carr;

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


// Pythagorean theorem
float distance(Point a, Point b)
{
	const double dx = max_float64(a.x, b.x) - min_float64(a.x, b.x);
	const double dy = max_float64(a.y, b.y) - min_float64(a.y, b.y);
	const double dx2 = pow(dx, 2);
	const double dy2 = pow(dy, 2);
	return sqrt(dx2 + dy2);
}


float lineLength(Line line)
{
	return distance(line.a, line.b);
}


int main()
{
	const float lines_0_len = lineLength((Line){
		.a = pointZero,
		.b = pointOne});
	const float lines_1_len = lineLength((Line){
		.a = (Point){.x = 10, .y = 20},
		.b = (Point){.x = 30, .y = 40}});
	const float lines_2_len = lineLength((Line){
		.a = pointZero,
		.b = pointOne});
	const float lines_3_len = lineLength((Line){
		.a = (Point){.x = 10, .y = 20},
		.b = (Point){.x = 30, .y = 40}});

	printf("lines_0_len = %f\n", lines_0_len);
	printf("lines_1_len = %f\n", lines_1_len);

	return 0;
}

