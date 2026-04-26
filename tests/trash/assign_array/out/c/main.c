
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
static int32_t main_globalArray0[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
static int32_t main_globalArray1[10] = {0};

int main(void) {
	printf("test assign_array\n");
	__builtin_memcpy(&main_globalArray1, &main_globalArray0, sizeof(int32_t [10]));
	int32_t i;
	i = 0;
	while (i < 10) {
		const int32_t main_v = main_globalArray1[i];
		printf("globalArray1[%d] = %d\n", i, main_v);
		i = i + 1;
	}
	if (__builtin_memcmp(&main_globalArray0, &main_globalArray1, sizeof(int32_t [10])) == 0) {
		printf("globalArray test passed\n");
	} else {
		printf("globalArray test failed\n");
	}
	int32_t localArray0[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
	int32_t localArray1[10] = {0};
	__builtin_memcpy(&localArray1, &localArray0, sizeof(int32_t [10]));
	i = 0;
	while (i < 10) {
		const int32_t main_v = localArray1[i];
		printf("localArray1[%d] = %d\n", i, main_v);
		i = i + 1;
	}
	if (__builtin_memcmp(&localArray0, &localArray1, sizeof(int32_t [10])) == 0) {
		printf("localArray test passed\n");
	} else {
		printf("localArray test failed\n");
	}
	return 0;
}

