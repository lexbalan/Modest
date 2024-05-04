// test/assign_array/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




static int32_t globalArray0[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
static int32_t globalArray1[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};


int main()
{
	printf("test assign_array\n");

	memcpy(&globalArray1, &globalArray0, 40);

	int32_t i;
	i = 0;
	while (i < 10) {
		const int32_t v = globalArray1[i];
		printf("globalArray1[%d] = %d\n", i, v);
		i = i + 1;
	}

	if (memcmp(&globalArray0, &globalArray1, sizeof globalArray0) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}

