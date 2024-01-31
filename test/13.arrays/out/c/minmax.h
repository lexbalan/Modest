// ./out/c/minmax.h


#include <string.h>
#ifndef MINMAX_H
#define MINMAX_H

#include <stdint.h>
#include <stdbool.h>


int32_t min_int32(int32_t a, int32_t b);
int32_t max_int32(int32_t a, int32_t b);

int64_t min_int64(int64_t a, int64_t b);
int64_t max_int64(int64_t a, int64_t b);


uint32_t min_nat32(uint32_t a, uint32_t b);
uint32_t max_nat32(uint32_t a, uint32_t b);

uint64_t min_nat64(uint64_t a, uint64_t b);
uint64_t max_nat64(uint64_t a, uint64_t b);


float min_float32(float a, float b);
float max_float32(float a, float b);

double min_float64(double a, double b);
double max_float64(double a, double b);

#endif  /* MINMAX_H */
