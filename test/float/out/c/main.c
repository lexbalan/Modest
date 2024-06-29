// test/float/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <math.h>
/* forward type declaration */
/* anon recs */





#define mathPi  3.141592653589793238462643383279502884


double squareOfCircle(double radius)
{
	return pow(radius, 2) * mathPi;
}


int main()
{
	printf("float test\n");

	#define r  10
	const double s = squareOfCircle(r);

	printf("s = %f\n", s);

	return 0;
}

#undef r

