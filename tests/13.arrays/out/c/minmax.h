// minmax.m

#ifndef MINMAX_H
#define MINMAX_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

int32_t minmax_minInt32(int32_t a, int32_t b);
int32_t minmax_maxInt32(int32_t a, int32_t b);
int64_t minmax_minInt64(int64_t a, int64_t b);
int64_t minmax_maxInt64(int64_t a, int64_t b);
uint32_t minmax_minNat32(uint32_t a, uint32_t b);
uint32_t minmax_maxNat32(uint32_t a, uint32_t b);
uint64_t minmax_minNat64(uint64_t a, uint64_t b);
uint64_t minmax_maxNat64(uint64_t a, uint64_t b);
float minmax_min_float32(float a, float b);
float minmax_max_float32(float a, float b);
double minmax_min_float64(double a, double b);
double minmax_max_float64(double a, double b);

#endif /* MINMAX_H */
