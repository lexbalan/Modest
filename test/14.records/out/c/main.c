// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



struct __anonymous_struct_3 {uint32_t x; uint32_t y;};
struct __anonymous_struct_4 {uint32_t x; uint32_t y;};

struct main_Point2D {
	uint32_t x;
	uint32_t y;
};

struct main_Point3D {
	uint32_t x;
	uint32_t y;
	uint32_t z;
};
#define xx  {.x = 1, .y = 2}
#define yy  {.x = 1, .y = 2}
int main();



int main()
{
	printf("records test\n");

	// compare two Point2D records
	main_Point2D p2d0;
	p2d0 = (main_Point2D){.x = 1, .y = 2};
	main_Point2D p2d1;
	p2d1 = (main_Point2D){.x = 10, .y = 20};

	if (memcmp(&p2d0, &p2d1, sizeof(main_Point2D)) == 0) {
		printf("p2d0 == p2d1\n");
	} else {
		printf("p2d0 != p2d1\n");
	}


	// compare Point2D with anonymous record
	main_Point2D p2d2;
	p2d2 = p2d0;
	struct __anonymous_struct_3 p2d3;
	p2d3 = (struct __anonymous_struct_3)xx;

	if (memcmp(&p2d2, &p2d3, sizeof(struct __anonymous_struct_3)) == 0) {
		printf("p2d2 == p2d3\n");
	} else {
		printf("p2d2 != p2d3\n");
	}


	// comparison between two anonymous record
	struct __anonymous_struct_4 p2d4;
	p2d4 = (struct __anonymous_struct_4){.x = 1, .y = 2};

	if (memcmp(&p2d3, &p2d4, sizeof(struct __anonymous_struct_4)) == 0) {
		printf("p2d3 == p2d4\n");
	} else {
		printf("p2d3 != p2d4\n");
	}

	// comparison between two record (by pointer)
	main_Point2D *const pr2 = &p2d2;
	struct __anonymous_struct_3 *const pr3 = &p2d3;

	if (memcmp(pr2, pr3, sizeof(struct __anonymous_struct_3)) == 0) {
		printf("*pr2 == *pr3\n");
	} else {
		printf("*pr2 != *pr3\n");
	}


	// assign record by pointer
	*pr2 = (main_Point2D){.x = 100, .y = 200};
	*pr3 = (struct __anonymous_struct_3){};

	// cons Point3D from Point2D (record extension)
	// (it is possible if dst record contained all fields from src record
	// and their types are equal)
	main_Point3D p3d;
	p3d = *(main_Point3D *)&p2d2;


	// проверка того как локальная константа-массив
	// "замораживает" свои элементы

	int32_t ax;
	ax = 10;
	int32_t bx;
	bx = 20;

	const struct {int32_t x; int32_t y;} px = {.x = ax, .y = bx};

	ax = 111;
	bx = 222;

	printf("px.x = %i (must be 10)\n", px.x);
	printf("px.y = %i (must be 20)\n", px.y);

	if (memcmp(&px, &(struct {int32_t x; int32_t y;}){.x = 10, .y = 20}, sizeof(struct {int32_t x; int32_t y;})) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}


	return 0;
}

