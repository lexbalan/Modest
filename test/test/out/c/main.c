// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



static int32_t a0[2 * 2 * 5] = (int32_t[2 * 2 * 5]){

	0, 1, 2, 3, 4,
	5, 6, 7, 8, 9,

	10, 11, 12, 13, 14,
	15, 16, 17, 18, 19
};

static int32_t a1[5] = (int32_t[5]){0, 1, 2, 3, 4};
static int32_t a2[5] = (int32_t[5]){5, 6, 7, 8, 9};
static int32_t *a3[2] = (int32_t *[2]){&a1[0], &a2[0]};
static int32_t *(*a4[2])[2] = (int32_t *(*[2])[2]){&a3, &a3};

static void test_arrays()
{
	int32_t i;
	int32_t j;
	int32_t k;

	i = 0;
	while (i < 2) {
		j = 0;
		while (j < 2) {
			k = 0;
			while (k < 5) {
				printf("a3[%d][%d][%d] = %d\n", i, j, k, a0[i * 2 * 5 + j * 5 + k]);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}
	//
	//
	i = 0;
	while (i < 2) {
		j = 0;
		while (j < 5) {
			printf("a3[%d][%d] = %d\n", i, j, a3[i][j]);
			j = j + 1;
		}
		i = i + 1;
	}
	//
	//
	i = 0;
	while (i < 2) {
		j = 0;
		while (j < 2) {
			k = 0;
			while (k < 5) {
				printf("a3[%d][%d][%d] = %d\n", i, j, k, (*a4[i])[j][k]);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}
}


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

static Line line = {
	.a = {.x = 10, .y = 11},
	.b = {.x = 12, .y = 13}
};

static Line lines[3] = (Line[3]){
	{
		.a = {.x = 1, .y = 2},
		.b = {.x = 3, .y = 4}
	},
	{
		.a = {.x = 5, .y = 6},
		.b = {.x = 7, .y = 8}
	},
	{
		.a = {.x = 9, .y = 10},
		.b = {.x = 11, .y = 12}
	}
};

static Line *pLines[3] = (Line *[3]){&lines[0], &lines[1], &lines[2]};

struct Struct {
	Line *x;
};
typedef struct Struct Struct;

static Struct s = {.x = &lines[0]};


static void test_records()
{

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


	Struct x = s;

	printf("x.x.a.x = %d\n", x.x->a.x);
	printf("x.x.a.y = %d\n", x.x->a.y);

	printf("x.x.b.x = %d\n", x.x->b.x);
	printf("x.x.b.y = %d\n", x.x->b.y);
}


int32_t main()
{
	test_arrays();
	test_records();
	return 0;
}

