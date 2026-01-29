
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



/* anonymous records */
struct __anonymous_struct_3 {
	int32_t x;
	int32_t y;
};

// Test for composite types

// Pointers
static int32_t *p0;
static int32_t **p1;


// Functions
static void f0(void) {
	return;
}


static int32_t f1(int32_t x) {
	return x;
}


static int32_t f2(int32_t a, int32_t b) {
	return a + b;
}


static int32_t *f3(void) {
	return NULL;
}


static void f4(int32_t x, int32_t(*_sret_)[10]) {
	memcpy(_sret_, &((int32_t[10]){1, 2, 3}), sizeof(int32_t[10]));
}


static void f5(int32_t(*_a)[32], int32_t(*_sret_)[32]) {
	int32_t a[32];
	memcpy(a, _a, sizeof(int32_t[32]));
	memcpy(_sret_, &a, sizeof(int32_t[32]));
}


static int32_t(*f6(int32_t(*a)[32]))[32] {
	return NULL;
}


static void f7(void(*f)(void)) {
	return;
}


static void(*f8(void(*f)(void)))(void) {
	return &f0;
}


static void(**f9(void(*f)(void)))(void) {
	return NULL;
}


static void(**f10(void(**f)(void)))(void) {
	return f;
}


static void(**f11(int32_t(*(**f)(int32_t a, int32_t *b))[10]))(void) {
	return NULL;
}


static void(**f12(int32_t(*(**f)(int32_t(*a)[32], int32_t(**b)[64]))[10]))(void) {
	return NULL;
}


static void(**f13(int32_t(*(**f)(int32_t *(*a)[32], int32_t *(**b)[64]))[10]))(void) {
	return NULL;
}



// Pointers to function
static void(*pf0)(void) = &f0;
static int32_t(*pf1)(int32_t x) = &f1;
static int32_t(*pf2)(int32_t a, int32_t b) = &f2;
static int32_t *(*pf3)(void) = &f3;
static void(*pf4)(int32_t x, int32_t(*_sret_)[10]) = &f4;
static void(*pf5)(int32_t(*_a)[32], int32_t(*_sret_)[32]) = &f5;
static int32_t(*(*pf6)(int32_t(*a)[32]))[32] = &f6;
static void(*pf7)(void(*f)(void)) = &f7;
static void(*(*pf8)(void(*f)(void)))(void) = &f8;
static void(**(*pf9)(void(*f)(void)))(void) = &f9;
static void(**(*pf10)(void(**f)(void)))(void) = &f10;
static void(**(*pf11)(int32_t(*(**f)(int32_t a, int32_t *b))[10]))(void) = &f11;
static void(**(*pf12)(int32_t(*(**f)(int32_t(*a)[32], int32_t(**b)[64]))[10]))(void) = &f12;
static void(**(*pf13)(int32_t(*(**f)(int32_t *(*a)[32], int32_t *(**b)[64]))[10]))(void) = &f13;


// Arrays
static int32_t a0[5] = {0, 1, 2, 3, 4};
static int32_t *a1[5] = {&a0[0], &a0[1], &a0[2], &a0[3], &a0[4]};
static int32_t **a2[5] = {&a1[0], &a1[1], &a1[2], &a1[3], &a1[4]};
static void(*a3[5])(void) = {&f0};
static int a4[2][5] = {{0, 1, 2, 3, 4}, {5, 6, 7, 8, 9}};
static int(*a5[2])[5] = {&a4[0], &a4[1]};
// Проблема в том что мой getelementptr не умеет в цепь-молнию
// а здесь без нее никак... придется взяться за это и сделать наконец
//var a6: [2][5]*Int = [
//	[&a4[0][0], &a4[0][1], &a4[0][2], &a4[0][3], &a4[0][4]]
//	[&a4[1][0], &a4[1][1], &a4[1][2], &a4[1][3], &a4[1][4]]
//]

static int(*a7[2][5])[5] = {
	{&a0, &a0, &a0, &a0, &a0},
	{&a0, &a0, &a0, &a0, &a0}
};

static int(*(*a8[2][5])[2][5])[5] = {
	{&a7, &a7, &a7, &a7, &a7},
	{&a7, &a7, &a7, &a7, &a7}
};

static int(*(*(*a9[5])[10])[2])(int a);


//
static int32_t(*p2)[5] = &a0;
static int32_t(**p3)[5] = &p2;

struct RGB24 {
	uint8_t red;
	uint8_t green;
	uint8_t blue;
};
typedef struct RGB24 RGB24;

static RGB24 rgb0[2] = {
	{.red = 200, .green = 0, .blue = 0},
	{.red = 200, .green = 0, .blue = 0}
};

struct AnimationPoint {
	RGB24 color;
	uint32_t time;
};
typedef struct AnimationPoint AnimationPoint;

static AnimationPoint ap = (AnimationPoint){
	.color = (RGB24){
		.red = 200,
		.green = 0,
		.blue = 0
	},
	.time = 3000
};

static AnimationPoint animation0_points[5] = {
	{.color = {.red = 200, .green = 0, .blue = 0}, .time = 3},
	{.color = {.red = 0, .green = 200, .blue = 0}, .time = 30},
	{.color = {.red = 100, .green = 100, .blue = 0}, .time = 300},
	{.color = {.red = 254, .green = 254, .blue = 0}, .time = 20},
	{.color = {.red = 0, .green = 0, .blue = 255}, .time = 3000}
};

static AnimationPoint animation1_points[5] = {
	{.color = {.red = 200, .green = 0, .blue = 0}, .time = 3},
	{.color = {.red = 0, .green = 200, .blue = 0}, .time = 30},
	{.color = {.red = 100, .green = 100, .blue = 0}, .time = 300},
	{.color = {.red = 254, .green = 254, .blue = 0}, .time = 20},
	{.color = {.red = 0, .green = 0, .blue = 255}, .time = 3000}
};

static AnimationPoint animation2_points[5] = {
	{.color = {.red = 200, .green = 0, .blue = 0}, .time = 3},
	{.color = {.red = 0, .green = 200, .blue = 0}, .time = 30},
	{.color = {.red = 100, .green = 100, .blue = 0}, .time = 300},
	{.color = {.red = 255, .green = 254, .blue = 0}, .time = 20},
	{.color = {.red = 0, .green = 0, .blue = 255}, .time = 3000}
};

static void xy(struct __anonymous_struct_3 x) {
}


static int32_t arrr[3][3] = {
	{1, 2, 3},
	{4, 5, 6},
	{7, 8, 9}
};

static void(*arry[3][3])(void);

static int32_t add(int32_t a, int32_t b) {
	return a + b;
}


static int32_t sub(int32_t a, int32_t b) {
	return a - b;
}


static int32_t(*farr[2])(int32_t a, int32_t b) = {
	&add, &sub
};

typedef void He(void);

__attribute__((used))
static void he(He *x) {
	(void)x;
}


static void hi(char *x) {
	printf("Hi %s!\n", (char*)x);
}


static void(*hiarr[10])(char *x) = {
	&hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi
};

struct Wrap {
	void(*fhi)(char *x);
	int32_t(*fop)(int32_t a, int32_t b);
};
typedef struct Wrap Wrap;

static Wrap wrap0 = (Wrap){
	.fhi = &hi,
	.fop = &add
};

static Wrap *awrap[2] = {&wrap0, &wrap0};

int32_t main(void) {
	xy((struct __anonymous_struct_3){.x = 10, .y = 20});

	printf("test1 (eq): ");
	if (memcmp(&animation0_points, &animation1_points, sizeof(AnimationPoint[5])) == 0) {
		printf("eq\n");
	} else {
		printf("ne\n");
	}

	printf("test2 (ne): ");
	if (memcmp(&animation1_points, &animation2_points, sizeof(AnimationPoint[5])) == 0) {
		printf("eq\n");
	} else {
		printf("ne\n");
	}

	uint32_t i = 0;
	while (i < 3) {
		uint32_t j = 0;
		while (j < 3) {
			printf("arrr[%d][%d] = %d\n", i, j, arrr[i][j]);
			j = j + 1;
		}
		i = i + 1;
	}

	const int32_t _add = farr[0](5, 7);
	printf("farr[0](5, 7) = %d\n", _add);
	const int32_t _sub = farr[1](5, 7);
	printf("farr[1](5, 7) = %d\n", _sub);

	i = 0;
	while (i < 10) {
		hiarr[i]("LOL");
		i = i + 1;
	}

	awrap[0]->fhi("World");
	//let y = awrap[0]
	//y.fhi("World")

	return 0;
}


