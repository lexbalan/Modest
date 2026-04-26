
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#define MAIN_POINT0 {.x = 0, .y = 0}
#define MAIN_POINT1 {.x = 1, .y = 0}
#define MAIN_POINT12 {.x = 1, .y = 1}

bool main_testRecordsEq(void) {
	if (__builtin_memcmp(&(struct {int8_t x; int8_t y;})MAIN_POINT0, &(struct {int8_t x; int8_t y;})MAIN_POINT0, sizeof(struct {int8_t x; int8_t y;})) != 0) {
		printf("point0 != point0\n");
		return false;
	}
	if (__builtin_memcmp(&(struct {int8_t x; int8_t y;})MAIN_POINT1, &(struct {int8_t x; int8_t y;})MAIN_POINT1, sizeof(struct {int8_t x; int8_t y;})) != 0) {
		printf("point1 != point1\n");
		return false;
	}
	if (__builtin_memcmp(&(struct {int8_t x; int8_t y;})MAIN_POINT12, &(struct {int8_t x; int8_t y;})MAIN_POINT12, sizeof(struct {int8_t x; int8_t y;})) != 0) {
		printf("point0 != point0\n");
		return false;
	}
	if (__builtin_memcmp(&(struct {int8_t x; int8_t y;})MAIN_POINT0, &(struct {int8_t x; int8_t y;})MAIN_POINT1, sizeof(struct {int8_t x; int8_t y;})) == 0) {
		printf("point0 == point1\n");
		return false;
	}
	if (__builtin_memcmp(&(struct {int8_t x; int8_t y;})MAIN_POINT1, &(struct {int8_t x; int8_t y;})MAIN_POINT0, sizeof(struct {int8_t x; int8_t y;})) == 0) {
		printf("point1 == point0\n");
		return false;
	}
	if (__builtin_memcmp(&(struct {int8_t x; int8_t y;})MAIN_POINT0, &(struct {int8_t x; int8_t y;})MAIN_POINT12, sizeof(struct {int8_t x; int8_t y;})) == 0) {
		printf("point0 == point12\n");
		return false;
	}
	printf("passed: record eq test\n");
	return true;
}
#define MAIN_ARR123 {1, 2, 3}
#define MAIN_ARR321 {3, 2, 1}
#define MAIN_CARR123 {1, 2, 3}
#define MAIN_CARR321 {3, 2, 1}
static int32_t main_varr123[3] = {1, 2, 3};
static int32_t main_varr321[3] = {3, 2, 1};

bool main_testArraysEq(void) {
	if (__builtin_memcmp(&(const int8_t [3])MAIN_ARR123, &(const int8_t [3])MAIN_ARR123, sizeof(const int8_t [3])) != 0) {
		printf("arr123 != arr123\n");
		return false;
	}
	if (__builtin_memcmp(&(const int8_t [3])MAIN_ARR321, &(const int8_t [3])MAIN_ARR321, sizeof(const int8_t [3])) != 0) {
		printf("arr321 != arr321\n");
		return false;
	}
	if (__builtin_memcmp(&(const int32_t [3])MAIN_ARR123, &(const int32_t [3])MAIN_CARR123, sizeof(const int32_t [3])) != 0) {
		printf("arr123 != carr123\n");
		return false;
	}
	if (__builtin_memcmp(&(const int32_t [3])MAIN_CARR123, &(const int32_t [3])MAIN_ARR123, sizeof(const int32_t [3])) != 0) {
		printf("carr123 != arr123\n");
		return false;
	}
	if (__builtin_memcmp(&(const int8_t [3])MAIN_ARR123, &(const int8_t [3])MAIN_ARR321, sizeof(const int8_t [3])) == 0) {
		printf("arr123 == arr321\n");
		return false;
	}
	if (__builtin_memcmp(&(const int32_t [3])MAIN_CARR123, &(const int32_t [3])MAIN_CARR321, sizeof(const int32_t [3])) == 0) {
		printf("carr123 == carr321\n");
		return false;
	}
	if (__builtin_memcmp(&main_varr123, &main_varr123, sizeof(int32_t [3])) != 0) {
		printf("varr123 != varr123\n");
		return false;
	}
	if (__builtin_memcmp(&main_varr321, &main_varr321, sizeof(int32_t [3])) != 0) {
		printf("varr321 != varr321\n");
		return false;
	}
	if (__builtin_memcmp(&main_varr123, &(int32_t [3])MAIN_ARR123, sizeof(int32_t [3])) != 0) {
		printf("varr123 != arr123\n");
		return false;
	}
	if (__builtin_memcmp(&main_varr123, &(const int32_t [3])MAIN_CARR123, sizeof(int32_t [3])) != 0) {
		printf("varr123 != carr123\n");
		return false;
	}
	if (__builtin_memcmp(&main_varr321, &(int32_t [3])MAIN_ARR321, sizeof(int32_t [3])) != 0) {
		printf("varr321 != arr321\n");
		return false;
	}
	if (__builtin_memcmp(&main_varr321, &(const int32_t [3])MAIN_CARR321, sizeof(int32_t [3])) != 0) {
		printf("varr321 != carr321\n");
		return false;
	}
	printf("passed: array eq test\n");
	return true;
}

int32_t main(void) {
	printf("test eq\n");
	bool result = true;
	result = main_testRecordsEq() && result;
	result = main_testArraysEq() && result;
	printf("test ");
	if (!result) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

