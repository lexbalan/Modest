// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"





struct main_Point {
	float x;
	float y;
};

struct main_Line {
	main_Point a;
	main_Point b;
};
float max(float a, float b);
float min(float a, float b);
float distance(main_Point a, main_Point b);
float lineLength(main_Line line);
void ptr_example();







static main_Line line = {
	.a = {.x = 0, .y = 0},
	.b = {.x = 1.0, .y = 1.0}
};

float max(float a, float b)
{
	if (a > b) {
		return a;
	}
	return b;
}

float min(float a, float b)
{
	if (a < b) {
		return a;
	}
	return b;
}

float distance(main_Point a, main_Point b)
{
	const float dx = max(a.x, b.x) - min(a.x, b.x);
	const float dy = max(a.y, b.y) - min(a.y, b.y);
	const double dx2 = pow(dx, (double)(2));
	const double dy2 = pow(dy, (double)(2));
	return sqrt(dx2 + dy2);
}

float lineLength(main_Line line)
{
	return distance(line.a, line.b);
}

void ptr_example()
{
	main_Point *const ptr_p = (main_Point *)malloc(sizeof(main_Point));

	// access by pointer
	ptr_p->x = (float)(10);
	ptr_p->y = (float)(20);

	printf("point(%f, %f)\n", ptr_p->x, ptr_p->y);
}

int main()
{
	// by value
	const float len = lineLength(line);
	printf("line length = %f\n", len);

	ptr_example();

	return 0;
}

