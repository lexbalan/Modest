
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



/* anonymous records */
struct __anonymous_struct_6 {
	uint32_t x;
	uint32_t y;
};
struct __anonymous_struct_7 {
	uint32_t x;
	uint32_t y;
};

struct Point2D {
	uint32_t x;
	uint32_t y;
};
typedef struct Point2D Point2D;

struct Point3D {
	uint32_t x;
	uint32_t y;
	uint32_t z;
};
typedef struct Point3D Point3D;

#define XX  {.x = 1, .y = 2}
#define YY  (Point2D){.x = 1, .y = 2}

struct Point {
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

struct Line {
	Point a;
	Point b;
};
typedef struct Line Line;

static Line line = (Line){
	.a = (Point){.x = 10, .y = 11},
	.b = (Point){.x = 12, .y = 13}
};

static Line lines[3] = {
	(Line){
		.a = (Point){.x = 1, .y = 2},
		.b = (Point){.x = 3, .y = 4}
	},
	(Line){
		.a = (Point){.x = 5, .y = 6},
		.b = (Point){.x = 7, .y = 8}
	},
	(Line){
		.a = (Point){.x = 9, .y = 10},
		.b = (Point){.x = 11, .y = 12}
	}
};

static Line *pLines[3] = {&lines[0], &lines[1], &lines[2]};

struct Struct {
	Line *x;
};
typedef struct Struct Struct;

static Struct s = (Struct){.x = &lines[0]};

static void test_records(void) {

	// Now local types not works
	//	type LocalRecord = record {
	//		x: Int32
	//	}
	//
	//	var localRecord: LocalRecord
	//	Unit localRecord

	printf(/*4*/"line.a.x = %d\n", line.a.x);
	printf(/*4*/"line.a.y = %d\n", line.a.y);

	printf(/*4*/"line.b.x = %d\n", line.b.x);
	printf(/*4*/"line.b.y = %d\n", line.b.y);

	printf(/*4*/"pLines[0].a.x = %d\n", pLines[0]->a.x);
	printf(/*4*/"pLines[0].a.y = %d\n", pLines[0]->a.y);

	printf(/*4*/"pLines[0].b.x = %d\n", pLines[0]->b.x);
	printf(/*4*/"pLines[0].b.y = %d\n", pLines[0]->b.y);

	printf(/*4*/"s.x.a.x = %d\n", s.x->a.x);
	printf(/*4*/"s.x.a.y = %d\n", s.x->a.y);

	printf(/*4*/"s.x.b.x = %d\n", s.x->b.x);
	printf(/*4*/"s.x.b.y = %d\n", s.x->b.y);


	const Struct x = s;

	printf(/*4*/"x.x.a.x = %d\n", x.x->a.x);
	printf(/*4*/"x.x.a.y = %d\n", x.x->a.y);

	printf(/*4*/"x.x.b.x = %d\n", x.x->b.x);
	printf(/*4*/"x.x.b.y = %d\n", x.x->b.y);
}


int main(void) {
	printf(/*4*/"records test\n");

	// check value_record_eq for immediate values
	#define ver  {.major = 0, .minor = 7}
	if (true) {
		printf(/*4*/"version 0.7\n");
	} else {
		printf(/*4*/"version not 0.7\n");
	}

	// compare two Point2D records
	Point2D p2d0 = (Point2D){.x = 1, .y = 2};
	Point2D p2d1 = (Point2D){.x = 10, .y = 20};

	if (memcmp(&p2d0, &p2d1, sizeof(Point2D)) == 0) {
		printf(/*4*/"p2d0 == p2d1\n");
	} else {
		printf(/*4*/"p2d0 != p2d1\n");
	}


	// compare Point2D with anonymous record
	Point2D p2d2 = p2d0;// record assignation
	struct __anonymous_struct_6 p2d3 = (struct __anonymous_struct_6){.x = 1, .y = 2};

	if (memcmp(&p2d2, &p2d3, sizeof(Point2D)) == 0) {
		printf(/*4*/"p2d2 == p2d3\n");
	} else {
		printf(/*4*/"p2d2 != p2d3\n");
	}


	// comparison between two anonymous record
	struct __anonymous_struct_7 p2d4 = (struct __anonymous_struct_7){.x = 1, .y = 2};

	if (memcmp(&p2d3, &p2d4, sizeof(struct __anonymous_struct_6)) == 0) {
		printf(/*4*/"p2d3 == p2d4\n");
	} else {
		printf(/*4*/"p2d3 != p2d4\n");
	}

	// comparison between two record (by pointer)
	Point2D *const pr2 = &p2d2;
	struct __anonymous_struct_6 *const pr3 = &p2d3;

	if (memcmp(pr2, pr3, sizeof(Point2D)) == 0) {
		printf(/*4*/"*pr2 == *pr3\n");
	} else {
		printf(/*4*/"*pr2 != *pr3\n");
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
	*pr2 = (Point2D){.x = 100, .y = 200};
	*pr3 = (struct __anonymous_struct_6){0};

	// cons Point3D from Point2D (record extension)
	// (it is possible if dst record contained all fields from src record
	// and their types are equal)  ((EXPERIMENTAL))
	//
	// Сейчас нельзя конструировать запись не из generic (!)
	//var p3d: Point3D
	//p3d = Point3D p2d2
	//Unit p3d


	// проверка того как локальная константа-массив
	// "замораживает" свои элементы

	int32_t ax = 10;
	int32_t bx = 20;

	struct {int32_t x; int32_t y;} px = {.x = ax, .y = bx};

	ax = 111;
	bx = 222;

	printf(/*4*/"px.x = %i (must be 10)\n", px.x);
	printf(/*4*/"px.y = %i (must be 20)\n", px.y);

	if (memcmp(&px, &((struct {int32_t x; int32_t y;}){.x = 10, .y = 20}), sizeof(struct {int32_t x; int32_t y;})) == 0) {
		printf(/*4*/"test passed\n");
	} else {
		printf(/*4*/"test failed\n");
	}

	test_records();

	return 0;

#undef ver
}


