
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

static Point globalPoint0 = (Point){.x = 10, .y = 20};
static Point globalPoint1 = (Point){0};

int main(void) {
	printf(/*4*/"test assign_array\n");

	globalPoint1 = globalPoint0;

	printf(/*4*/"globalPoint1.x = %d\n", globalPoint1.x);
	printf(/*4*/"globalPoint1.x = %d\n", globalPoint1.y);

	if (memcmp(&globalPoint0, &globalPoint1, sizeof(Point)) == 0) {
		printf(/*4*/"globalPoint test passed\n");
	} else {
		printf(/*4*/"globalPoint test failed\n");
	}

	// local

	Point localPoint0 = (Point){.x = 10, .y = 20};
	Point localPoint1 = (Point){0};

	localPoint1 = localPoint0;

	printf(/*4*/"localPoint1.x = %d\n", localPoint1.x);
	printf(/*4*/"localPoint1.x = %d\n", localPoint1.y);

	if (memcmp(&localPoint0, &localPoint1, sizeof(Point)) == 0) {
		printf(/*4*/"localPoint test passed\n");
	} else {
		printf(/*4*/"localPoint test failed\n");
	}

	return 0;
}


