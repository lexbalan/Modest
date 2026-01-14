
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>




// Simply record for records assignation test
struct Point {
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

static int32_t glb_i0 = 0;
static int32_t glb_i1 = 321;

static Point glb_r0 = {0};
static Point glb_r1 = {.x = 20, .y = 10};

static int32_t glb_a0[10] = {0};
static int32_t glb_a1[10] = {64, 53, 42};

int main(void) {
	printf("test assignation\n");

	// -----------------------------------
	// Global

	// copy integers by value
	glb_i0 = glb_i1;
	printf("glb_i0 = %i\n", glb_i0);


	// copy arrays by value
	memcpy(&glb_a0, &glb_a1, sizeof(int32_t[10]));

	printf("glb_a0[0] = %i\n", glb_a0[0]);
	printf("glb_a0[1] = %i\n", glb_a0[1]);
	printf("glb_a0[2] = %i\n", glb_a0[2]);


	// copy records by value
	glb_r0 = glb_r1;

	printf("glb_r0.x = %i\n", glb_r0.x);
	printf("glb_r0.y = %i\n", glb_r0.y);


	// -----------------------------------
	// Local

	// copy integers by value
	int32_t loc_i0 = 0;
	int32_t loc_i1 = 123;

	loc_i0 = loc_i1;

	printf("loc_i0 = %i\n", loc_i0);

	// copy arrays by value
	// C backend will be use memcpy()
	int32_t loc_a0[10] = {0};
	int32_t loc_a1[10] = {42, 53, 64};

	memcpy(&loc_a0, &loc_a1, sizeof(int32_t[10]));

	printf("loc_a0[0] = %i\n", loc_a0[0]);
	printf("loc_a0[1] = %i\n", loc_a0[1]);
	printf("loc_a0[2] = %i\n", loc_a0[2]);


	// copy records by value
	// C backend will be use memcpy()
	Point loc_r0 = (Point){0};
	Point loc_r1 = (Point){.x = 10, .y = 20};

	loc_r0 = loc_r1;

	printf("loc_r0.x = %i\n", loc_r0.x);
	printf("loc_r0.y = %i\n", loc_r0.y);


	// error: closed arrays of closed arrays are denied
	/*let dim1 = 15
	let dim2 = 16

	var aa: [dim1][dim2]Int32

	var i: Nat32 = 0
	while i < 16 {
		var j: Nat32 = 0
		while j < 16 {
			aa[i][j] = i * j
			j = j + 1
		}
		i = i + 1
	}

	i = 0
	while i < 16 {
		var k = 0
		while k < 16 {
			printf("aa[%i][%i] = %i\n", i, k, aa[i][k])
			k = k + 1
		}
		i = i + 1
	}


	let xa = aa[3]

	i = 0
	while i < dim2 {
		printf("xa[%i] = %i\n", i, xa[i])
		i = i + 1
	}*/


	return 0;
}


