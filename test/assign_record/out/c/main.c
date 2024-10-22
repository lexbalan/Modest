// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"





struct main_Point {
	int32_t x;
	int32_t y;
};



static main_Point globalPoint0 = {.x = 10, .y = 20};
static main_Point globalPoint1 = {};

int main()
{
	printf("test assign_array\n");

	globalPoint1 = globalPoint0;

	printf("globalPoint1.x = %d\n", globalPoint1.x);
	printf("globalPoint1.x = %d\n", globalPoint1.y);

	if (memcmp(&globalPoint0, &globalPoint1, sizeof(main_Point)) == 0) {
		printf("globalPoint test passed\n");
	} else {
		printf("globalPoint test failed\n");
	}

	// local

	main_Point localPoint0;
	localPoint0 = (main_Point){.x = 10, .y = 20};
	main_Point localPoint1;
	localPoint1 = (main_Point){};

	localPoint1 = localPoint0;

	printf("localPoint1.x = %d\n", localPoint1.x);
	printf("localPoint1.x = %d\n", localPoint1.y);

	if (memcmp(&localPoint0, &localPoint1, sizeof(main_Point)) == 0) {
		printf("localPoint test passed\n");
	} else {
		printf("localPoint test failed\n");
	}

	return 0;
}

