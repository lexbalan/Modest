// test/14.records/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
struct __anonymous_struct_3 {uint32_t x; uint32_t y;};
struct __anonymous_struct_4 {uint32_t x; uint32_t y;};



//TODO: now runtime requires memcmp declaration
// for records & arrays eq



typedef struct {
	uint32_t x;
	uint32_t y;
} Point2D;

typedef struct {
	uint32_t x;
	uint32_t y;
	uint32_t z;
} Point3D;


#define xx  {.x = 1, .y = 2}
#define yy  {.x = 1, .y = 2}


int main()
{
	printf("records test\n");

	// compare two Point2D records
	Point2D p2d0;
	p2d0 = (Point2D){.x = 1, .y = 2};
	Point2D p2d1;
	p2d1 = (Point2D){.x = 10, .y = 20};

	if (memcmp(&p2d0, &p2d1, sizeof p2d0) == 0) {
		printf("p2d0 == p2d1\n");
	} else {
		printf("p2d0 != p2d1\n");
	}


	// compare Point2D with anonymous record
	Point2D p2d2;
	p2d2 = p2d0;
	struct __anonymous_struct_3 p2d3;
	p2d3 = (struct __anonymous_struct_3)xx;

	if (memcmp(&p2d2, &*(Point2D *)&p2d3, sizeof p2d2) == 0) {
		printf("p2d2 == p2d3\n");
	} else {
		printf("p2d2 != p2d3\n");
	}


	// comparison between two anonymous record
	struct __anonymous_struct_4 p2d4;
	p2d4 = (struct __anonymous_struct_4){.x = 1, .y = 2};

	if (memcmp(&p2d3, &p2d4, sizeof p2d3) == 0) {
		printf("p2d3 == p2d4\n");
	} else {
		printf("p2d3 != p2d4\n");
	}

	// comparison between two record (by pointer)
	Point2D *const pr2 = &p2d2;
	struct __anonymous_struct_3 *const pr3 = &p2d3;

	if (memcmp(&*pr2, &*(Point2D *)&*pr3, sizeof *pr2) == 0) {
		printf("*pr2 == *pr3\n");
	} else {
		printf("*pr2 != *pr3\n");
	}


	// cons Point3D from Point2D (record extension)
	// (it is possible if dst record contained all fields from src record
	// and their types are equal)
	Point3D p3d;
	p3d = *(Point3D *)&p2d2;


	return 0;
}

