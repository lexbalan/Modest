
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>




/*@deprecated*/
struct Point {
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

#define M_Y  5

__attribute__((used))
static Point returnPoint(void) {
	Point p;
	p.x = 10;
	return p;
}


int32_t main(void) {
	printf("Hello World!\n");
	Point p = (Point){
		.x = 32,
		.y = 32
	};
	p = (Point){
		.x = 32,
		.y = 32
	};
	M_Y;

	//var a: []Int64
	int64_t b;
	int32_t c;
	//a = a * b + c
	//offsetof(Point.y)
	//p.z
	//a = (2 + 2)
	//var j: jey.Jey
	return 0;
}


