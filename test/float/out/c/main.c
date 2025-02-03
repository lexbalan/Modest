
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


#define main_mathPi  3.141592653589793238462643383279502884


static double main_squareOfCircle(double radius)
{
	return pow(radius, (double)(2)) * main_mathPi;
}


struct main_Point2D {
	int x;
	int y;
};
typedef struct main_Point2D main_Point2D;


static float main_slope(main_Point2D a, main_Point2D b)
{
	int dx = abs(a.x - b.x);
	int dy = abs(a.y - b.y);
	printf("dx = %d\n", dx);
	printf("dy = %d\n", dy);
	return (float)dy / (float)dx;
}


int main()
{
	printf("float test\n");

	printf("2 = %d\n", 2);
	printf("2/3 = %f\n", (double)(2.0 / (double)(3)));

	#define __r  10
	double s = main_squareOfCircle((double)__r);
	printf("s = %f\n", s);

	#define __k  (1.0 / (double)(8))
	printf("k = %f\n", (double)__k);

	printf("sizeof(Float32) = %lu\n", sizeof(float));
	printf("sizeof(Float64) = %lu\n", sizeof(double));

	// printf %f ожидает получить double а не float!
	float sl = main_slope((main_Point2D){.x = 10, .y = 20	}, (main_Point2D){.x = 30, .y = 50	});
	printf("slope = %f\n", (double)sl);

	return 0;

#undef __r
#undef __k
}

