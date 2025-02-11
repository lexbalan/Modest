
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#include <math.h>
#include <stdlib.h>
#include <stdio.h>


struct main_Point {
	float x;
	float y;
};
typedef struct main_Point main_Point;

struct main_Line {
	main_Point a;
	main_Point b;
};
typedef struct main_Line main_Line;


static main_Line main_line = {
	.a = {.x = 0, .y = 0	},
	.b = {.x = 1.0, .y = 1.0	}
};




static float main_max(float a, float b)
{
	if (a > b) {
		return a;
	}
	return b;
}



static float main_min(float a, float b)
{
	if (a < b) {
		return a;
	}
	return b;
}


// Pythagorean theorem
static float main_distance(main_Point a, main_Point b)
{
	float dx = main_max(a.x, b.x) - main_min(a.x, b.x);
	float dy = main_max(a.y, b.y) - main_min(a.y, b.y);
	double dx2 = pow(dx, (double)(2));
	double dy2 = pow(dy, (double)(2));
	return sqrt(dx2 + dy2);
}


static float main_lineLength(main_Line line)
{
	return main_distance(line.a, line.b);
}


static void main_ptr_example()
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
	float len = main_lineLength(main_line);
	printf("line length = %f\n", len);

	main_ptr_example();

	return 0;
}

