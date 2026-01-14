
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



struct Point {
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

int32_t main(void) {
	printf("Hello World!\n");
	Point p = (Point){.x = 0, .y = 0};
	return 0;
}


