
#include <stdint.h>

#include <stdio.h>

#define arraySize  10

uint32_t array[arraySize] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

void arrayExample() {
	printf("array example\n");
	uint32_t i = 0;
	while(i < arraySize) {
		printf("array[%d] = %d\n", i, array[i]);
		i = i + 1;
	}
}

uint32_t arrayOfArrays[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};

void arrayOfArraysExample() {
	printf("array of arrays example\n");
	uint32_t m = 0;
	while(m < 3) {
		uint32_t n = 0;
		while(n < 3) {
			printf("arr[%d][%d] = %d\n", m, n, arrayOfArrays[m][n]);
			n = n + 1;
		}
		m = m + 1;
	}
}

int main() {
	arrayExample();
	arrayOfArraysExample();
	return 0;
}

