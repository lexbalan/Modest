// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"





struct Point2 {
	int32_t x;
	int32_t y;
};



Int main()
{
	#define __a  10
	#define __b  20
	const Int s = mid(__a, __b);

	printf("s = %d\n", s);

	// access to private value
	//let x = lib.div(a, b)

	Point2 p;
	p = (Point2){.x = 10, .y = 20};
	printPoint(*(Point *)&p);

	return 0;
}

#undef __a
#undef __b

