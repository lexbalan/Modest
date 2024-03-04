// test/float/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <math.h>




#define iota  0.0000000000000000000000000000000000001
#define mathPi  (3.141592653589793238462643383279502884 + iota)

double squareOfCircle(double r)
{
    return pow(r, 2) * mathPi;
}


int main()
{
    printf("float test\n");

    #define r  10
    const double s = squareOfCircle(r);

    printf("s = %f\n", s);

    return 0;
#undef r
}

