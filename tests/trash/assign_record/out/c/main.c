
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
struct point {
	int32_t x;
	int32_t y;
};
static struct point globalPoint0 = (struct point){.x = 10, .y = 20};
static struct point globalPoint1 = (struct point){0};

int main(void) {
	printf("test assign_array\n");
	globalPoint1 = globalPoint0;
	printf("globalPoint1.x = %d\n", globalPoint1.x);
	printf("globalPoint1.x = %d\n", globalPoint1.y);
	if (memcmp(&globalPoint0, &globalPoint1, sizeof(struct point)) == 0) {
		printf("globalPoint test passed\n");
	} else {
		printf("globalPoint test failed\n");
	}
	struct point localPoint0 = (struct point){.x = 10, .y = 20};
	struct point localPoint1 = (struct point){0};
	localPoint1 = localPoint0;
	printf("localPoint1.x = %d\n", localPoint1.x);
	printf("localPoint1.x = %d\n", localPoint1.y);
	if (memcmp(&localPoint0, &localPoint1, sizeof(struct point)) == 0) {
		printf("localPoint test passed\n");
	} else {
		printf("localPoint test failed\n");
	}
	return 0;
}
