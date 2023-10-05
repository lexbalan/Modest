
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm

// s = sign
// p = exponent
// n = fraction
float float32(bool s, uint8_t p, uint32_t n)
{
    uint32_t bits;

    if (s) {
        bits = 0x80000000;
    }

    bits = bits | (uint32_t)p << 23;
    bits = bits | n & 0x7FFFFF;

    // bitcast Nat32 to Float32
    float *pfloat32;
    pfloat32 = (float *)(void *)&bits;
    return *pfloat32;
}



void test2(void)
{
    const int8_t n = 1;
    const int8_t p = -128;

    printf("n = %d\n", (int32_t)n);
    printf("p = %d\n", (int32_t)p);

    const float f = float32(false, p, n);

    printf("t2 = %f\n", f);
}

#define M_PI  3.141592653589793

int main(void)
{
    printf("Hello World!\n");

    //test2()

    const double pi = M_PI;

    float f;
    f = pi;

    double d;
    d = pi;

    printf("f = %f\n", (double)f);
    printf("d = %lf\n", d);
    printf("pi = %lf\n", (double)pi);

    return 0;

/*let n = (1 to Nat32) << 21
    let p = 0x7C

    printf("n = %d\n", n)
    printf("p = %d\n", p)

    let f = float32(false, p, n)
    if f == 0.156250 to Float32 {
        printf("test float32 ok\n")
    }

    printf("f = %f\n", f)*/

    return 0;
}

