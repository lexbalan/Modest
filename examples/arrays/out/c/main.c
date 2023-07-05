
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

void fillArray() {
	int i = 0;
	while(i < arraySize) {
		printf("arr[%d] = ", i);
		scanf("%d", &array[i]);
		i = i + 1;
	}
}

void sortBubble(uint32_t *arr, uint32_t len);

int main() {
	fillArray();
	sortBubble((uint32_t*)&array[0], 10);
	arrayExample();
	return 0;
}

// bubble sort
void sortBubble(uint32_t *arr, uint32_t len) {
	uint8_t end = 0;
	while(!end) {
		end = 1;
		uint32_t i = 0;
		while(i < len - 1) {
			const uint32_t a = arr[i];
			const uint32_t b = arr[i + 1];
			if(a > b) {
				arr[i] = b;
				arr[i + 1] = a;
				end = 0;
			}
			i = i + 1;
		}
	}
}

