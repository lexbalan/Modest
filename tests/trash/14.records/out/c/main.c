
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#define RAWCAST(type_dst, type_src, value) (((union { type_src src; type_dst dst; }){ .src = (value) }).dst)
struct __anonymous_struct_6 {uint32_t x; uint32_t y;};
struct __anonymous_struct_7 {uint32_t x; uint32_t y;};
struct main_point2_d {
	uint32_t x;
	uint32_t y;
};
struct main_point3_d {
	uint32_t x;
	uint32_t y;
	uint32_t z;
};
#define MAIN_XX {.x = 1, .y = 2}
#define MAIN_YY ((struct main_point2_d){.x = 1, .y = 2})
typedef struct main_point main_Point;
struct main_point {
	int32_t x;
	int32_t y;
};
typedef struct main_line main_Line;
struct main_line {
	main_Point a;
	main_Point b;
};
static main_Line main_line = (main_Line){
	.a = {.x = 10, .y = 11},
	.b = {.x = 12, .y = 13}
};
static main_Line main_lines[3] = {
	(main_Line){
		.a = {.x = 1, .y = 2},
		.b = {.x = 3, .y = 4}
	},
	(main_Line){
		.a = {.x = 5, .y = 6},
		.b = {.x = 7, .y = 8}
	},
	(main_Line){
		.a = {.x = 9, .y = 10},
		.b = {.x = 11, .y = 12}
	}
};
static main_Line *main_pLines[3] = {&main_lines[0], &main_lines[1], &main_lines[2]};
struct main_structx {
	main_Line *x;
};
static struct main_structx main_s = (struct main_structx){.x = &main_lines[0]};

static void main_test_records(void) {
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
	const struct main_structx main_x = main_s;
	printf("x.x.a.x = %d\n", main_x.x->a.x);
	printf("x.x.a.y = %d\n", main_x.x->a.y);
	printf("x.x.b.x = %d\n", main_x.x->b.x);
	printf("x.x.b.y = %d\n", main_x.x->b.y);
}

int main(void) {
	printf("records test\n");
	struct {uint32_t major; uint32_t minor; uint32_t patch;} main_ver = {.major = 0U, .minor = 7U, .patch = 100U};
	if (__builtin_memcmp(&main_ver, &(struct {uint32_t major; uint32_t minor; uint32_t patch;}){.major = 0, .minor = 7, .patch = 100}, sizeof(struct {uint32_t major; uint32_t minor; uint32_t patch;})) == 0) {
		printf("version 0.7\n");
	} else {
		printf("version not 0.7\n");
	}
	struct main_point2_d p2d0 = (struct main_point2_d){.x = 1, .y = 2};
	struct main_point2_d p2d1 = (struct main_point2_d){.x = 10, .y = 20};
	if (__builtin_memcmp(&p2d0, &p2d1, sizeof(struct main_point2_d)) == 0) {
		printf("p2d0 == p2d1\n");
	} else {
		printf("p2d0 != p2d1\n");
	}
	struct main_point2_d p2d2 = p2d0;
	struct __anonymous_struct_6 p2d3 = (struct __anonymous_struct_6)MAIN_XX;
	if (__builtin_memcmp(&p2d2, &RAWCAST(struct main_point2_d, struct __anonymous_struct_6, p2d3), sizeof(struct main_point2_d)) == 0) {
		printf("p2d2 == p2d3\n");
	} else {
		printf("p2d2 != p2d3\n");
	}
	struct __anonymous_struct_7 p2d4 = (struct __anonymous_struct_7){.x = 1, .y = 2};
	if (__builtin_memcmp(&p2d3, &p2d4, sizeof(struct __anonymous_struct_6)) == 0) {
		printf("p2d3 == p2d4\n");
	} else {
		printf("p2d3 != p2d4\n");
	}
	struct main_point2_d *const main_pr2 = &p2d2;
	struct __anonymous_struct_6 *const main_pr3 = &p2d3;
	if (__builtin_memcmp(main_pr2, &RAWCAST(struct main_point2_d, struct __anonymous_struct_6, *main_pr3), sizeof(struct main_point2_d)) == 0) {
		printf("*pr2 == *pr3\n");
	} else {
		printf("*pr2 != *pr3\n");
	}
	*main_pr2 = (struct main_point2_d){.x = 100, .y = 200};
	*main_pr3 = (struct __anonymous_struct_6){0};
	int32_t ax = 10;
	int32_t bx = 20;
	struct {int32_t x; int32_t y;} main_px = {.x = ax, .y = bx};
	ax = 111;
	bx = 222;
	printf("px.x = %i (must be 10)\n", main_px.x);
	printf("px.y = %i (must be 20)\n", main_px.y);
	if (__builtin_memcmp(&main_px, &(struct {int32_t x; int32_t y;}){.x = 10, .y = 20}, sizeof(struct {int32_t x; int32_t y;})) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}
	main_test_records();
	return 0;
}

