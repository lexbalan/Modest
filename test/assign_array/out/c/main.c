
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#include <stdio.h>


static int32_t main_globalArray0[10] = (int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
static int32_t main_globalArray1[10] = (int32_t[10]){};


int main()
{
	printf("test assign_array\n");

	memcpy(&main_globalArray1, &main_globalArray0, sizeof main_globalArray1);

	int32_t i;

	i = 0;
	while (i < 10) {
		int32_t v = main_globalArray1[i];
		printf("globalArray1[%d] = %d\n", i, v);
		i = i + 1;
	}

	if (memcmp(&main_globalArray0, &main_globalArray1, sizeof(int32_t[10])) == 0) {
		printf("globalArray test passed\n");
	} else {
		printf("globalArray test failed\n");
	}


	// local

	int32_t localArray0[10];
	memcpy(&localArray0, &(int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9	}, sizeof localArray0);
	int32_t localArray1[10];
	memset(&localArray1, 0, sizeof localArray1);


	memcpy(&localArray1, &localArray0, sizeof localArray1);

	i = 0;
	while (i < 10) {
		int32_t v = localArray1[i];
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

