
#include <stdint.h>
#include <string.h>

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

typedef struct {
	float x;
	float y;
} Point;


typedef struct {
	Point a;
	Point b;
} Line;


Line line = {
	.a={
		.x=0.0,
		.y=0.0
	},
	.b={
		.x=1.0,
		.y=1.0
	}
};

float max(float a, float b)
{
	if(a > b) {
		return a;
	}
	return b;
}

float min(float a, float b)
{
	if(a < b) {
		return a;
	}
	return b;
}

float lineLength(Line line)
{
	const float dx = max(line.a.x, line.b.x) - min(line.a.x, line.b.x);
	const float dy = max(line.a.y, line.b.y) - min(line.a.y, line.b.y);
	const double dx2 = pow(dx, 2.0);
	const double dy2 = pow(dy, 2.0);
	const double len = sqrt(dx2 + dy2);
	return len;
}

Point *ptr_p;

void ptr_example()
{
	ptr_p = malloc(sizeof(Point));
	ptr_p->x = 10.0;
	ptr_p->y = 20.0;
	printf("point(%f, %f)\n", ptr_p->x, ptr_p->y);
}

int main()
{
	const float len = lineLength(line);
	printf("line length = %f\n", len);
	ptr_example();
	return 0;
}

