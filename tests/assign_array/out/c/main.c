
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"

#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */


static int32_t globalArray0[10] = (int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
static int32_t globalArray1[10] = (int32_t[10]){};

int main()
{
	printf("test assign_array\n");

	for (uint32_t i__ = 0; i__ < __lengthof(globalArray1); i__++) {
		globalArray1[i__] = globalArray0[i__];
	};

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

	int32_t localArray0[10];
	for (uint32_t i__ = 0; i__ < __lengthof(localArray0); i__++) {
		localArray0[i__] = (int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9	}[i__];
	};
	int32_t localArray1[10];
	memset(&localArray1, 0, sizeof(int32_t[10]));


	for (uint32_t i__ = 0; i__ < __lengthof(localArray1); i__++) {
		localArray1[i__] = localArray0[i__];
	};

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

