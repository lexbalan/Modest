
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



struct __attribute__((deprecated)) Point {
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

#define M_Y  5

int32_t main(void) {
	printf("Hello World!\n");
	Point p = (Point){.x = 0, .y = 0};
	M_Y;
	return 0;
}


