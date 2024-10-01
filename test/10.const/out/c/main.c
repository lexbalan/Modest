// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"





struct main_Point {
	double x;
	double y;
};

struct main_Line {
	main_Point a;
	main_Point b;
};
#define main_zero  0
#define main_pointZero  {.x = main_zero, .y = main_zero}
#define main_pointOne  {.x = 1.0, .y = 1.0}
#define main_line0  { \
	.a = main_pointZero, \
	.b = main_pointOne \
}
#define _main_carr  {0, 10, 15, 20, 25, 30}
const int8_t main_carr[6] = _main_carr;
#define main_line1  { \
	.a = {.x = 10, .y = 20}, \
	.b = {.x = 30, .y = 40} \
}
#define main_line2  { \
	.a = main_pointZero, \
	.b = main_pointOne \
}
#define main_line3  { \
	.a = {.x = 10, .y = 20}, \
	.b = {.x = 30, .y = 40} \
}
#define _main_lines  {main_line0, main_line1, main_line2, main_line3}
const main_Line main_lines[4] = _main_lines;
float distance(main_Point a, main_Point b);
float lineLength(main_Line line);
int main();






float distance(main_Point a, main_Point b)
{
	const double dx = minmax_max_float64(a.x, b.x) - minmax_min_float64(a.x, b.x);
	const double dy = minmax_max_float64(a.y, b.y) - minmax_min_float64(a.y, b.y);
	const double dx2 = pow(dx, (double)(2));
	const double dy2 = pow(dy, (double)(2));
	return sqrt(dx2 + dy2);
}

float lineLength(main_Line line)
{
	return distance(line.a, line.b);
}

int main()
{
	const float lines_0_len = lineLength(main_lines[0]);
	const float lines_1_len = lineLength(main_lines[1]);
	const float lines_2_len = lineLength(main_lines[2]);
	const float lines_3_len = lineLength(main_lines[3]);

	printf("lines_0_len = %f\n", lines_0_len);
	printf("lines_1_len = %f\n", lines_1_len);

	return 0;
}

