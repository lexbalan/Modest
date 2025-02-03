
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"
/* anonymous records */
struct __anonymous_struct_6 {uint32_t x; uint32_t y;
};
struct __anonymous_struct_7 {uint32_t x; uint32_t y;
};
#include <stdio.h>

struct main_Point2D {
	uint32_t x;
	uint32_t y;
};
typedef struct main_Point2D main_Point2D;

struct main_Point3D {
	uint32_t x;
	uint32_t y;
	uint32_t z;
};
typedef struct main_Point3D main_Point3D;


#define main_xx  {.x = 1, .y = 2}
#define main_yy  {.x = 1, .y = 2}




struct main_Point {
	int32_t x;
	int32_t y;
};
typedef struct main_Point main_Point;

struct main_Line {
	main_Point a;
	main_Point b;
};
typedef struct main_Line main_Line;

static main_Line main_line = {
	.a = {.x = 10, .y = 11	},
	.b = {.x = 12, .y = 13	}
};

static main_Line main_lines[3] = (main_Line[3]){
	{
		.a = {.x = 1, .y = 2		},
		.b = {.x = 3, .y = 4		}
	},
	{
		.a = {.x = 5, .y = 6		},
		.b = {.x = 7, .y = 8		}
	},
	{
		.a = {.x = 9, .y = 10		},
		.b = {.x = 11, .y = 12		}
	}
};

static main_Line *main_pLines[3] = (main_Line *[3]){&main_lines[0], &main_lines[1], &main_lines[2]};

struct main_Struct {
	main_Line *x;
};
typedef struct main_Struct main_Struct;

static main_Struct main_s = {.x = &main_lines[0]};


static void main_test_records()
{
	printf("line.a.x = %d\n", main_line.a.x);
	printf("line.a.y = %d\n", main_line.a.y);

	printf("line.b.x = %d\n", main_line.b.x);
	printf("line.b.y = %d\n", main_line.b.y);

	printf("pLines[0].a.x = %d\n", main_pLines[0]->a.x);
	printf("pLines[0].a.y = %d\n", main_pLines[0]->a.y);

	printf("pLines[0].b.x = %d\n", main_pLines[0]->b.x);
	printf("pLines[0].b.y = %d\n", main_pLines[0]->b.y);

	printf("s.x.a.x = %d\n", main_s.x->a.x);
	printf("s.x.a.y = %d\n", main_s.x->a.y);

	printf("s.x.b.x = %d\n", main_s.x->b.x);
	printf("s.x.b.y = %d\n", main_s.x->b.y);


	main_Struct x = main_s;

	printf("x.x.a.x = %d\n", x.x->a.x);
	printf("x.x.a.y = %d\n", x.x->a.y);

	printf("x.x.b.x = %d\n", x.x->b.x);
	printf("x.x.b.y = %d\n", x.x->b.y);
}


int main()
{
	printf("records test\n");

	// check value_record_eq for immediate values
	#define __ver  {.major = 0, .minor = 7	}
	if (true) {
		printf("version 0.7\n");
	} else {
		printf("version not 0.7\n");
	}

	// compare two Point2D records
	main_Point2D p2d0 = (main_Point2D){.x = 1, .y = 2	};
	main_Point2D p2d1 = (main_Point2D){.x = 10, .y = 20	};

	if (memcmp(&p2d0, &p2d1, sizeof(main_Point2D)) == 0) {
		printf("p2d0 == p2d1\n");
	} else {
		printf("p2d0 != p2d1\n");
	}


	// compare Point2D with anonymous record
	main_Point2D p2d2 = p2d0;
	struct __anonymous_struct_6 p2d3 = (struct __anonymous_struct_6)main_xx;

	if (memcmp(&p2d2, &p2d3, sizeof(main_Point2D)) == 0) {
		printf("p2d2 == p2d3\n");
	} else {
		printf("p2d2 != p2d3\n");
	}


	// comparison between two anonymous record
	struct __anonymous_struct_7 p2d4 = (struct __anonymous_struct_7){.x = 1, .y = 2	};

	if (memcmp(&p2d3, &p2d4, sizeof(struct __anonymous_struct_6)) == 0) {
		printf("p2d3 == p2d4\n");
	} else {
		printf("p2d3 != p2d4\n");
	}

	// comparison between two record (by pointer)
	main_Point2D *pr2 = &p2d2;
	struct __anonymous_struct_6 *pr3 = &p2d3;

	if (memcmp(&*pr2, &*pr3, sizeof(main_Point2D)) == 0) {
		printf("*pr2 == *pr3\n");
	} else {
		printf("*pr2 != *pr3\n");
	}

	/*
	var prx = &p2d2
	var prx2 = &prx
	var pry = &p2d3

	if **prx2 == *pry {
		printf("**prx2 == *pry\n")
	} else {
		printf("**prx2 != *pry\n")
	}
*/

	// assign record by pointer
	*pr2 = (main_Point2D){.x = 100, .y = 200	};
	*pr3 = (struct __anonymous_struct_6){	};

	// cons Point3D from Point2D (record extension)
	// (it is possible if dst record contained all fields from src record
	// and their types are equal)  ((EXPERIMENTAL))
	main_Point3D p3d;
	p3d = *(main_Point3D*)&p2d2;


	// проверка того как локальная константа-массив
	// "замораживает" свои элементы

	int32_t ax = 10;
	int32_t bx = 20;

	struct {int32_t x; int32_t y;
	} __px = {.x = ax, .y = bx	};

	ax = 111;
	bx = 222;

	printf("px.x = %i (must be 10)\n", __px.x);
	printf("px.y = %i (must be 20)\n", __px.y);

	if (memcmp(&__px, &(struct {int32_t x; int32_t y;
	}){.x = 10, .y = 20	}, sizeof(struct {int32_t x; int32_t y;
	})) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	main_test_records();

	return 0;

#undef __ver
}

