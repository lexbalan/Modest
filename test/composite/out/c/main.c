// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"


static main_RGB24 rgb0[2] = (main_RGB24[2]){{.red = 200, .green = 0, .blue = 0}, {.red = 200, .green = 0, .blue = 0}};

struct AnimationPoint {
	main_RGB24 color;
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


int32_t main()
{
	if (memcmp(&animation0_points, &animation1_points, sizeof(AnimationPoint[5])) == 0) {
		printf("eq\n");
	} else {
		printf("ne\n");
	}
	return 0;
}

