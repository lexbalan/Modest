
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#define RAWCAST(type_dst, type_src, value) (((union { type_src src; type_dst dst; }){ .src = (value) }).dst)
struct __anonymous_struct_6 {uint32_t x; uint32_t y;};
struct __anonymous_struct_7 {uint32_t x; uint32_t y;};
struct point2_d {
	uint32_t x;
	uint32_t y;
};
struct point3_d {
	uint32_t x;
	uint32_t y;
	uint32_t z;
};
#define XX {.x = 1, .y = 2}
#define YY (struct point2_d){.x = 1, .y = 2}
typedef struct point Point;
struct point {
	int32_t x;
	int32_t y;
};
typedef struct line Line;
struct line {
	Point a;
	Point b;
};
static Line line = (Line){
	.a = {.x = 10, .y = 11},
	.b = {.x = 12, .y = 13}
};
static Line lines[3] = {(Line){
	.a = {.x = 1, .y = 2},
	.b = {.x = 3, .y = 4}
}, (Line){
	.a = {.x = 5, .y = 6},
	.b = {.x = 7, .y = 8}
}, (Line){
	.a = {.x = 9, .y = 10},
	.b = {.x = 11, .y = 12}
}};
static Line *pLines[3] = {&lines[0], &lines[1], &lines[2]};
struct structx {
	Line *x;
};
static struct structx s = (struct structx){.x = &lines[0]};

static void test_records(void) {
	printf("line.a.x = %d\n", line.a.x);
	printf("line.a.y = %d\n", line.a.y);
	printf("line.b.x = %d\n", line.b.x);
	printf("line.b.y = %d\n", line.b.y);
	printf("pLines[0].a.x = %d\n", pLines[0]->a.x);
	printf("pLines[0].a.y = %d\n", pLines[0]->a.y);
	printf("pLines[0].b.x = %d\n", pLines[0]->b.x);
	printf("pLines[0].b.y = %d\n", pLines[0]->b.y);
	printf("s.x.a.x = %d\n", s.x->a.x);
	printf("s.x.a.y = %d\n", s.x->a.y);
	printf("s.x.b.x = %d\n", s.x->b.x);
	printf("s.x.b.y = %d\n", s.x->b.y);
	const struct structx x = s;
	printf("x.x.a.x = %d\n", x.x->a.x);
	printf("x.x.a.y = %d\n", x.x->a.y);
	printf("x.x.b.x = %d\n", x.x->b.x);
	printf("x.x.b.y = %d\n", x.x->b.y);
}

int main(void) {
	printf("records test\n");
	#define ver {.major = 0, .minor = 7}
	if (memcmp(/*AP2*/(&(struct {uint32_t major; uint32_t minor;})ver), /*AP2*/(&(struct {uint32_t major; uint32_t minor;}){.major = 0, .minor = 7}), sizeof(struct {uint32_t major; uint32_t minor;})) == 0) {
		printf("version 0.7\n");
	} else {
		printf("version not 0.7\n");
	}
	struct point2_d p2d0 = (struct point2_d){.x = 1, .y = 2};
	struct point2_d p2d1 = (struct point2_d){.x = 10, .y = 20};
	if (memcmp(&p2d0, &p2d1, sizeof(struct point2_d)) == 0) {
		printf("p2d0 == p2d1\n");
	} else {
		printf("p2d0 != p2d1\n");
	}
	struct point2_d p2d2 = p2d0;
	struct __anonymous_struct_6 p2d3 = (struct __anonymous_struct_6)XX;
	if (memcmp(&p2d2, &p2d3, sizeof(struct point2_d)) == 0) {
		printf("p2d2 == p2d3\n");
	} else {
		printf("p2d2 != p2d3\n");
	}
	struct __anonymous_struct_7 p2d4 = (struct __anonymous_struct_7){.x = 1, .y = 2};
	if (memcmp(&p2d3, &p2d4, sizeof(struct __anonymous_struct_6)) == 0) {
		printf("p2d3 == p2d4\n");
	} else {
		printf("p2d3 != p2d4\n");
	}
	struct point2_d *const pr2 = &p2d2;
	struct __anonymous_struct_6 *const pr3 = &p2d3;
	if (memcmp(pr2, pr3, sizeof(struct point2_d)) == 0) {
		printf("*pr2 == *pr3\n");
	} else {
		printf("*pr2 != *pr3\n");
	}
	*pr2 = (struct point2_d){.x = 100, .y = 200};
	*pr3 = (struct __anonymous_struct_6){0};
	int32_t ax = 10;
	int32_t bx = 20;
	struct {int32_t x; int32_t y;} px = {.x = ax, .y = bx};
	ax = 111;
	bx = 222;
	printf("px.x = %i (must be 10)\n", px.x);
	printf("px.y = %i (must be 20)\n", px.y);
	if (memcmp(&px, /*AP2*/(&(struct {int32_t x; int32_t y;}){.x = 10, .y = 20}), sizeof(struct {int32_t x; int32_t y;})) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}
	test_records();
	return 0;
	#undef ver
}

