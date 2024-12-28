// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

/* anonymous records */
struct __anonymous_struct_3 {int32_t x; int32_t y;};


struct RGB24 {
	uint8_t red;
	uint8_t green;
	uint8_t blue;
};
typedef struct RGB24 RGB24;

static RGB24 rgb0[2] = (RGB24[2]){
	{.red = 200, .green = 0, .blue = 0},
	{.red = 200, .green = 0, .blue = 0}
};

struct AnimationPoint {
	RGB24 color;
	uint32_t time;
};
typedef struct AnimationPoint AnimationPoint;

static AnimationPoint ap = {.color = {.red = 200, .green = 0, .blue = 0}, .time = 3000};


static AnimationPoint animation0_points[5] = (AnimationPoint[5]){
	{.color = {.red = 200, .green = 0, .blue = 0}, .time = 3},
	{.color = {.red = 0, .green = 200, .blue = 0}, .time = 30},
	{.color = {.red = 100, .green = 100, .blue = 0}, .time = 300},
	{.color = {.red = 254, .green = 254, .blue = 0}, .time = 20},
	{.color = {.red = 0, .green = 0, .blue = 255}, .time = 3000}
};

static AnimationPoint animation1_points[5] = (AnimationPoint[5]){
	{.color = {.red = 200, .green = 0, .blue = 0}, .time = 3},
	{.color = {.red = 0, .green = 200, .blue = 0}, .time = 30},
	{.color = {.red = 100, .green = 100, .blue = 0}, .time = 300},
	{.color = {.red = 254, .green = 254, .blue = 0}, .time = 20},
	{.color = {.red = 0, .green = 0, .blue = 255}, .time = 3000}
};

static AnimationPoint animation2_points[5] = (AnimationPoint[5]){
	{.color = {.red = 200, .green = 0, .blue = 0}, .time = 3},
	{.color = {.red = 0, .green = 200, .blue = 0}, .time = 30},
	{.color = {.red = 100, .green = 100, .blue = 0}, .time = 300},
	{.color = {.red = 255, .green = 254, .blue = 0}, .time = 20},
	{.color = {.red = 0, .green = 0, .blue = 255}, .time = 3000}
};


static void xy(struct __anonymous_struct_3 x)
{
}


static int32_t arrr[3 * 3] = (int32_t[3 * 3]){
	1, 2, 3,
	4, 5, 6,
	7, 8, 9
};

static void(*f0)();
static void(*arry[3 * 3])();


static int32_t add(int32_t a, int32_t b)
{
	return a + b;
}

static int32_t sub(int32_t a, int32_t b)
{
	return a - b;
}


static int32_t(*farr[2])(int32_t a, int32_t b) = (int32_t(*[2])(int32_t a, int32_t b)){
	&add, &sub
};

static void hi(char *x)
{
	printf("Hi %s!\n", x);
}

static void(*hiarr[10])(char *x) = (void(*[10])(char *x)){
	&hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi
};

struct Wrap {
	void(*fhi)(char *x);
	int32_t(*fop)(int32_t a, int32_t b);
};
typedef struct Wrap Wrap;

static Wrap wrap0 = {
	.fhi = &hi,
	.fop = &add
};

static Wrap *awrap[2] = (Wrap *[2]){&wrap0, &wrap0};

int32_t main()
{
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

	int32_t i = 0;
	while (i < 3) {
		int32_t j = 0;
		while (j < 3) {
			printf("arrr[%d][%d] = %d\n", i, j, arrr[i * 3 + j]);
			j = j + 1;
		}
		i = i + 1;
	}

	int32_t _add = farr[0](5, 7);
	printf("farr[0](5, 7) = %d\n", _add);
	int32_t _sub = farr[1](5, 7);
	printf("farr[1](5, 7) = %d\n", _sub);

	i = 0;
	while (i < 10) {
		hiarr[i]("LOL");
		i = i + 1;
	}

	awrap[0]->fhi("World");

	return 0;
}

