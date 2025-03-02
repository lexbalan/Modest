
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"


struct POINT {
	int32_t x;
	int32_t y;
};
typedef struct POINT POINT;

#define STR  "Hi!"

static int32_t vaw;

static void func()
{
}

int32_t main()
{
	POINT p;
	printf("test %s\n", (char *)STR);
	printf("test %d\n", vaw);
	func();
	return 0;
}

