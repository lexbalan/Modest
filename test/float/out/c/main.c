// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define mathPi  3.141592653589793238462643383279502884


struct Point2D {
	int x;
	int y;
};
double squareOfCircle(double radius);
float slope(Point2D a, Point2D b);








double squareOfCircle(double radius)
{
	return pow(radius, (double)(2)) * mathPi;
}

float slope(Point2D a, Point2D b)
{
	const int dx = abs(a.x - b.x);
	const int dy = abs(a.y - b.y);
	printf("dx = %d\n", dx);
	printf("dy = %d\n", dy);
	return (float)dy / (float)dx;
}

int main()
{
	printf("float test\n");

	#define __r  10
	const double s = squareOfCircle((double)__r);
	printf("s = %f\n", s);


	#define __k  (1.0 / (double)(8))
	printf("k = %f\n", __k);

	printf("sizeof(Float32) = %lu\n", sizeof(float));
	printf("sizeof(Float64) = %lu\n", sizeof(double));

	// printf %f ожидает получить double а не float!
	const float sl = slope((Point2D){.x = 10, .y = 20}, (Point2D){.x = 30, .y = 50});
	printf("slope = %f\n", (double)sl);

	return 0;

#undef __r
#undef __k
}

