// test/float/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <math.h>




#define mathPi  3.14159265358979323846264338327950

double squareOfCircle(double r)
{
    return pow(r, 2) * mathPi;
}


int main()
{
    printf("float test\n");

    #define r  1
    const double s = squareOfCircle(r);


    printf("s = %F\n", s);

    return 0;
#undef r
}

