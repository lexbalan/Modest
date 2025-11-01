// tests/assign_array/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static int32_t globalArray0[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
static int32_t globalArray1[10] = {0};

int main(void) {
	printf("test assign_array\n");

	memcpy(&globalArray1, &globalArray0, sizeof(int32_t[10]));

	int32_t i;

	i = 0;
	while (i < 10) {
		const int32_t v = globalArray1[i];
		printf("globalArray1[%d] = %d\n", i, v);
		i = i + 1;
	}

	if (memcmp(&globalArray0, &globalArray1, sizeof(int32_t[10])) == 0) {
		printf("globalArray test passed\n");
	} else {
		printf("globalArray test failed\n");
	}


	// local

	int32_t localArray0[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
	int32_t localArray1[10] = {0};


	memcpy(&localArray1, &localArray0, sizeof(int32_t[10]));

	i = 0;
	while (i < 10) {
		const int32_t v = localArray1[i];
		printf("localArray1[%d] = %d\n", i, v);
		i = i + 1;
	}

	if (memcmp(&localArray0, &localArray1, sizeof(int32_t[10])) == 0) {
		printf("localArray test passed\n");
	} else {
		printf("localArray test failed\n");
	}

	return 0;
}


