// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



struct RGB24 {
	uint8_t red;
	uint8_t green;
	uint8_t blue;
};
typedef struct RGB24 RGB24;

static RGB24 rgb0[2] = (RGB24[2]){{.red = 200, .green = 0, .blue = 0}, {.red = 200, .green = 0, .blue = 0}};

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
//var arrr = [
//	[1, 2, 3]
//	[4, 5, 6]
//	[7, 8, 9]
//]


int32_t main()
{
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
	return 0;
}

