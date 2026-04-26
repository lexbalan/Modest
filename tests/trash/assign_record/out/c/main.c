
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
struct main_point {
	int32_t x;
	int32_t y;
};
static struct main_point main_globalPoint0 = (struct main_point){.x = 10, .y = 20};
static struct main_point main_globalPoint1 = (struct main_point){0};

int main(void) {
	printf("test assign_array\n");
	main_globalPoint1 = main_globalPoint0;
	printf("globalPoint1.x = %d\n", main_globalPoint1.x);
	printf("globalPoint1.x = %d\n", main_globalPoint1.y);
	if (__builtin_memcmp(&main_globalPoint0, &main_globalPoint1, sizeof(struct main_point)) == 0) {
		printf("globalPoint test passed\n");
	} else {
		printf("globalPoint test failed\n");
	}
	struct main_point localPoint0 = (struct main_point){.x = 10, .y = 20};
	struct main_point localPoint1 = (struct main_point){0};
	localPoint1 = localPoint0;
	printf("localPoint1.x = %d\n", localPoint1.x);
	printf("localPoint1.x = %d\n", localPoint1.y);
	if (__builtin_memcmp(&localPoint0, &localPoint1, sizeof(struct main_point)) == 0) {
		printf("localPoint test passed\n");
	} else {
		printf("localPoint test failed\n");
	}
	return 0;
}

