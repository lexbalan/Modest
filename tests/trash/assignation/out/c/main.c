
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
struct point {
	int32_t x;
	int32_t y;
};
static int32_t glb_i0 = 0;
static int32_t glb_i1 = 321;
static struct point glb_r0 = (struct point){0};
static struct point glb_r1 = (struct point){.x = 20, .y = 10};
static int32_t glb_a0[10] = {0};
static int32_t glb_a1[10] = {64, 53, 42};

int main(void) {
	printf("test assignation\n");
	glb_i0 = glb_i1;
	printf("glb_i0 = %i\n", glb_i0);
	memcpy(&glb_a0, &glb_a1, sizeof(int32_t [10]));
	printf("glb_a0[0] = %i\n", glb_a0[0]);
	printf("glb_a0[1] = %i\n", glb_a0[1]);
	printf("glb_a0[2] = %i\n", glb_a0[2]);
	glb_r0 = glb_r1;
	printf("glb_r0.x = %i\n", glb_r0.x);
	printf("glb_r0.y = %i\n", glb_r0.y);
	int32_t loc_i0 = 0;
	int32_t loc_i1 = 123;
	loc_i0 = loc_i1;
	printf("loc_i0 = %i\n", loc_i0);
	int32_t loc_a0[10] = {0};
	int32_t loc_a1[10] = {42, 53, 64};
	memcpy(&loc_a0, &loc_a1, sizeof(int32_t [10]));
	printf("loc_a0[0] = %i\n", loc_a0[0]);
	printf("loc_a0[1] = %i\n", loc_a0[1]);
	printf("loc_a0[2] = %i\n", loc_a0[2]);
	struct point loc_r0 = (struct point){0};
	struct point loc_r1 = (struct point){.x = 10, .y = 20};
	loc_r0 = loc_r1;
	printf("loc_r0.x = %i\n", loc_r0.x);
	printf("loc_r0.y = %i\n", loc_r0.y);
	return 0;
}
