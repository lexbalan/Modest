
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>



struct Point {
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

typedef int32_t MyInt32;
typedef MyInt32 MyInt322;

static void fx(MyInt322 i) {
	//
}


int32_t main(void) {
	printf("test2\n");

	Point p = (Point){.x = 0};

	printf("p.x = %d\n", p.x);
	printf("p.y = %d\n", p.y);


	fx((MyInt322)5);

	return 0;
}


