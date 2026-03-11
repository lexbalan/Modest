
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>


#define POINT0 {.x = 0, .y = 0}
#define POINT1 {.x = 1, .y = 0}
#define POINT12 {.x = 1, .y = 1}

bool main_testRecordsEq(void) {
	if (memcmp(&(struct  {int8_t x; int8_t y;})POINT0, &(struct  {int8_t x; int8_t y;})POINT0, sizeof(struct  {int8_t x; int8_t y;})) != 0) {
		printf("point0 != point0\n");
		return false;
	}
	if (memcmp(&(struct  {int8_t x; int8_t y;})POINT1, &(struct  {int8_t x; int8_t y;})POINT1, sizeof(struct  {int8_t x; int8_t y;})) != 0) {
		printf("point1 != point1\n");
		return false;
	}
	if (memcmp(&(struct  {int8_t x; int8_t y;})POINT12, &(struct  {int8_t x; int8_t y;})POINT12, sizeof(struct  {int8_t x; int8_t y;})) != 0) {
		printf("point0 != point0\n");
		return false;
	}
	if (memcmp(&(struct  {int8_t x; int8_t y;})POINT0, &(struct  {int8_t x; int8_t y;})POINT1, sizeof(struct  {int8_t x; int8_t y;})) == 0) {
		printf("point0 == point1\n");
		return false;
	}
	if (memcmp(&(struct  {int8_t x; int8_t y;})POINT1, &(struct  {int8_t x; int8_t y;})POINT0, sizeof(struct  {int8_t x; int8_t y;})) == 0) {
		printf("point1 == point0\n");
		return false;
	}
	if (memcmp(&(struct  {int8_t x; int8_t y;})POINT0, &(struct  {int8_t x; int8_t y;})POINT12, sizeof(struct  {int8_t x; int8_t y;})) == 0) {
		printf("point0 == point12\n");
		return false;
	}
	printf("passed: record eq test\n");
	return true;
}
#define ARR123 {1, 2, 3}
#define ARR321 {3, 2, 1}
#define CARR123 {1, 2, 3}
#define CARR321 {3, 2, 1}
static int32_t varr123[3] = {1, 2, 3};
static int32_t varr321[3] = {3, 2, 1};

bool main_testArraysEq(void) {
	if (memcmp(&(const int8_t [3])ARR123, &(const int8_t [3])ARR123, sizeof(const int8_t [3])) != 0) {
		printf("arr123 != arr123\n");
		return false;
	}
	if (memcmp(&(const int8_t [3])ARR321, &(const int8_t [3])ARR321, sizeof(const int8_t [3])) != 0) {
		printf("arr321 != arr321\n");
		return false;
	}
	if (memcmp(&(const int32_t [3])ARR123, &(const int32_t [3])CARR123, sizeof(const int32_t [3])) != 0) {
		printf("arr123 != carr123\n");
		return false;
	}
	if (memcmp(&(const int32_t [3])CARR123, &(const int32_t [3])ARR123, sizeof(const int32_t [3])) != 0) {
		printf("carr123 != arr123\n");
		return false;
	}
	if (memcmp(&(const int8_t [3])ARR123, &(const int8_t [3])ARR321, sizeof(const int8_t [3])) == 0) {
		printf("arr123 == arr321\n");
		return false;
	}
	if (memcmp(&(const int32_t [3])CARR123, &(const int32_t [3])CARR321, sizeof(const int32_t [3])) == 0) {
		printf("carr123 == carr321\n");
		return false;
	}
	if (memcmp(&varr123, &varr123, sizeof(int32_t [3])) != 0) {
		printf("varr123 != varr123\n");
		return false;
	}
	if (memcmp(&varr321, &varr321, sizeof(int32_t [3])) != 0) {
		printf("varr321 != varr321\n");
		return false;
	}
	if (memcmp(&varr123, &(int32_t [3])ARR123, sizeof(int32_t [3])) != 0) {
		printf("varr123 != arr123\n");
		return false;
	}
	if (memcmp(&varr123, &(const int32_t [3])CARR123, sizeof(int32_t [3])) != 0) {
		printf("varr123 != carr123\n");
		return false;
	}
	if (memcmp(&varr321, &(int32_t [3])ARR321, sizeof(int32_t [3])) != 0) {
		printf("varr321 != arr321\n");
		return false;
	}
	if (memcmp(&varr321, &(const int32_t [3])CARR321, sizeof(int32_t [3])) != 0) {
		printf("varr321 != carr321\n");
		return false;
	}
	printf("passed: array eq test\n");
	return true;
}

int32_t main(void) {
	printf("test eq\n");
	bool result;
	bool success = true;
	result = main_testRecordsEq();
	success = success && result;
	result = main_testArraysEq();
	success = success && result;
	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

