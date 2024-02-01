// ./out/c/minmax.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


int32_t min_int32(int32_t a, int32_t b)
{
    if (a < b) {
        return a;
    }
    return b;
}


int32_t max_int32(int32_t a, int32_t b)
{
    if (a > b) {
        return a;
    }
    return b;
}



int64_t min_int64(int64_t a, int64_t b)
{
    if (a < b) {
        return a;
    }
    return b;
}


int64_t max_int64(int64_t a, int64_t b)
{
    if (a > b) {
        return a;
    }
    return b;
}



uint32_t min_nat32(uint32_t a, uint32_t b)
{
    if (a < b) {
        return a;
    }
    return b;
}


uint32_t max_nat32(uint32_t a, uint32_t b)
{
    if (a > b) {
        return a;
    }
    return b;
}



uint64_t min_nat64(uint64_t a, uint64_t b)
{
    if (a < b) {
        return a;
    }
    return b;
}


uint64_t max_nat64(uint64_t a, uint64_t b)
{
    if (a > b) {
        return a;
    }
    return b;
}



float min_float32(float a, float b)
{
    if (a < b) {
        return a;
    }
    return b;
}


float max_float32(float a, float b)
{
    if (a > b) {
        return a;
    }
    return b;
}



double min_float64(double a, double b)
{
    if (a < b) {
        return a;
    }
    return b;
}


double max_float64(double a, double b)
{
    if (a > b) {
        return a;
    }
    return b;
}

