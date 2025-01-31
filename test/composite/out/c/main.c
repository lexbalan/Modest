
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

/* anonymous records */
struct __anonymous_struct_3 {int32_t x; int32_t y;
};
#include <stdio.h>


// Test for composite types

// Pointers
static int32_t *main_p0;
static int32_t **main_p1;


// Functions
static void main_f0()
{
	return;
}

static int32_t main_f1(int32_t x)
{
	return x;
}

static int32_t main_f2(int32_t a, int32_t b)
{
	return a + b;
}

static int32_t *main_f3()
{
	return NULL;
}

static void main_f4(int32_t x, int32_t *sret_)
{
	memcpy(sret_, &(int32_t[10]){1, 2, 3	}, sizeof(int32_t[10]));
}

static void main_f5(int32_t *_a, int32_t *sret_)
{
	int32_t a[32];
	memcpy(a, _a, sizeof(int32_t[32]));
	memcpy(sret_, &a, sizeof(int32_t[32]));
}

static int32_t *main_f6(int32_t *a)
{
	return NULL;
}

static void main_f7(void(*f)())
{
	return;
}

static void(*main_f8(void(*f)()))()
{
	return &main_f0;
}

static void(**main_f9(void(*f)()))()
{
	return NULL;
}

static void(**main_f10(void(**f)()))()
{
	return f;
}

static void(**main_f11(int32_t *(**f)(int32_t a, int32_t *b)))()
{
	return NULL;
}

static void(**main_f12(int32_t *(**f)(int32_t *a, int32_t(**b)[64])))()
{
	return NULL;
}

static void(**main_f13(int32_t *(**f)(int32_t *(*a)[32], int32_t *(**b)[64])))()
{
	return NULL;
}


// Pointers to function
static void(*main_pf0)() = &main_f0;
static int32_t(*main_pf1)(int32_t x) = &main_f1;
static int32_t(*main_pf2)(int32_t a, int32_t b) = &main_f2;
static int32_t *(*main_pf3)() = &main_f3;
static void(*main_pf4)(int32_t x, int32_t *sret_) = &main_f4;
static void(*main_pf5)(int32_t *_a, int32_t *sret_) = &main_f5;
static int32_t *(*main_pf6)(int32_t *a) = &main_f6;
static void(*main_pf7)(void(*f)()) = &main_f7;
static void(*(*main_pf8)(void(*f)()))() = &main_f8;
static void(**(*main_pf9)(void(*f)()))() = &main_f9;
static void(**(*main_pf10)(void(**f)()))() = &main_f10;
static void(**(*main_pf11)(int32_t *(**f)(int32_t a, int32_t *b)))() = &main_f11;
static void(**(*main_pf12)(int32_t *(**f)(int32_t *a, int32_t(**b)[64])))() = &main_f12;
static void(**(*main_pf13)(int32_t *(**f)(int32_t *(*a)[32], int32_t *(**b)[64])))() = &main_f13;


// Arrays
static int32_t main_a0[5] = (int32_t[5]){0, 1, 2, 3, 4};
static int32_t *main_a1[5] = (int32_t *[5]){&main_a0[0], &main_a0[1], &main_a0[2], &main_a0[3], &main_a0[4]};
static int32_t **main_a2[5] = (int32_t **[5]){&main_a1[0], &main_a1[1], &main_a1[2], &main_a1[3], &main_a1[4]};
static void(*main_a3[5])() = (void(*[5])()){&main_f0};
static int main_a4[2][5] = (int[2][5]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
static int *main_a5[2] = (int *[2]){&main_a4[0], &main_a4[1]};
// Проблема в том что мой getelementptr не умеет в цепь-молнию
// а здесь без нее никак... придется взяться за это и сделать наконец
//var a6: [2][5]*Int = [
//	[&a4[0][0], &a4[0][1], &a4[0][2], &a4[0][3], &a4[0][4]]
//	[&a4[1][0], &a4[1][1], &a4[1][2], &a4[1][3], &a4[1][4]]
//]
static int *main_a7[2][5] = (int *[2][5]){
	&main_a0, &main_a0, &main_a0, &main_a0, &main_a0,
	&main_a0, &main_a0, &main_a0, &main_a0, &main_a0
};
static int *(*main_a8[2][5])[2][5] = (int *(*[2][5])[2][5]){
	(void *)&main_a7, (void *)&main_a7, (void *)&main_a7, (void *)&main_a7, (void *)&main_a7,
	(void *)&main_a7, (void *)&main_a7, (void *)&main_a7, (void *)&main_a7, (void *)&main_a7
};
static int(*(*(*main_a9[5])[10])[2])(int a);


//
static int32_t *main_p2 = &main_a0;
static int32_t(**main_p3)[5] = &main_p2;




struct main_RGB24 {
	uint8_t red;
	uint8_t green;
	uint8_t blue;
};
typedef struct main_RGB24 main_RGB24;

static main_RGB24 main_rgb0[2] = (main_RGB24[2]){
	{.red = 200, .green = 0, .blue = 0	},
	{.red = 200, .green = 0, .blue = 0	}
};

struct main_AnimationPoint {
	main_RGB24 color;
	uint32_t time;
};
typedef struct main_AnimationPoint main_AnimationPoint;

static main_AnimationPoint main_ap = {
	.color = {
		.red = 200,
		.green = 0,
		.blue = 0
	},
	.time = 3000
};


static main_AnimationPoint main_animation0_points[5] = (main_AnimationPoint[5]){
	{.color = {.red = 200, .green = 0, .blue = 0		}, .time = 3	},
	{.color = {.red = 0, .green = 200, .blue = 0		}, .time = 30	},
	{.color = {.red = 100, .green = 100, .blue = 0		}, .time = 300	},
	{.color = {.red = 254, .green = 254, .blue = 0		}, .time = 20	},
	{.color = {.red = 0, .green = 0, .blue = 255		}, .time = 3000	}
};

static main_AnimationPoint main_animation1_points[5] = (main_AnimationPoint[5]){
	{.color = {.red = 200, .green = 0, .blue = 0		}, .time = 3	},
	{.color = {.red = 0, .green = 200, .blue = 0		}, .time = 30	},
	{.color = {.red = 100, .green = 100, .blue = 0		}, .time = 300	},
	{.color = {.red = 254, .green = 254, .blue = 0		}, .time = 20	},
	{.color = {.red = 0, .green = 0, .blue = 255		}, .time = 3000	}
};

static main_AnimationPoint main_animation2_points[5] = (main_AnimationPoint[5]){
	{.color = {.red = 200, .green = 0, .blue = 0		}, .time = 3	},
	{.color = {.red = 0, .green = 200, .blue = 0		}, .time = 30	},
	{.color = {.red = 100, .green = 100, .blue = 0		}, .time = 300	},
	{.color = {.red = 255, .green = 254, .blue = 0		}, .time = 20	},
	{.color = {.red = 0, .green = 0, .blue = 255		}, .time = 3000	}
};


static void main_xy(struct __anonymous_struct_3 x)
{
}


static int32_t main_arrr[3][3] = (int32_t[3][3]){
	1, 2, 3,
	4, 5, 6,
	7, 8, 9
};


static void(*main_arry[3][3])();


static int32_t main_add(int32_t a, int32_t b)
{
	return a + b;
}

static int32_t main_sub(int32_t a, int32_t b)
{
	return a - b;
}


static int32_t(*main_farr[2])(int32_t a, int32_t b) = (int32_t(*[2])(int32_t a, int32_t b)){
	&main_add, &main_sub
};

static void main_hi(char *x)
{
	printf("Hi %s!\n", x);
}

static void(*main_hiarr[10])(char *x) = (void(*[10])(char *x)){
	&main_hi, &main_hi, &main_hi, &main_hi, &main_hi, &main_hi, &main_hi, &main_hi, &main_hi, &main_hi
};

struct main_Wrap {
	void(*fhi)(char *x);
	int32_t(*fop)(int32_t a, int32_t b);
};
typedef struct main_Wrap main_Wrap;

static main_Wrap main_wrap0 = {
	.fhi = &main_hi,
	.fop = &main_add
};

static main_Wrap *main_awrap[2] = (main_Wrap *[2]){&main_wrap0, &main_wrap0};

int32_t main()
{
	main_xy((struct __anonymous_struct_3){.x = 10, .y = 20	});

	printf("test1 (eq): ");
	if (memcmp(&main_animation0_points, &main_animation1_points, sizeof(main_AnimationPoint[5])) == 0) {
		printf("eq\n");
	} else {
		printf("ne\n");
	}

	printf("test2 (ne): ");
	if (memcmp(&main_animation1_points, &main_animation2_points, sizeof(main_AnimationPoint[5])) == 0) {
		printf("eq\n");
	} else {
		printf("ne\n");
	}

	int32_t i = 0;
	while (i < 3) {
		int32_t j = 0;
		while (j < 3) {
			printf("arrr[%d][%d] = %d\n", i, j, main_arrr[i][j]);
			j = j + 1;
		}
		i = i + 1;
	}

	int32_t _add = main_farr[0](5, 7);
	printf("farr[0](5, 7) = %d\n", _add);
	int32_t _sub = main_farr[1](5, 7);
	printf("farr[1](5, 7) = %d\n", _sub);

	i = 0;
	while (i < 10) {
		main_hiarr[i]("LOL");
		i = i + 1;
	}

	main_awrap[0]->fhi("World");
	//let y = awrap[0]
	//y.fhi("World")

	return 0;
}

