// out/c/animation.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "animation.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))



struct animation_Color {
	uint8_t red;
	uint8_t green;
	uint8_t blue;
};

struct animation_AnimationPoint {
	uint8_t brightness;
	uint32_t time;
};

struct animation_Animation {
	uint32_t len;
	animation_AnimationPoint *points;
};



static led_LedController led0;
static animation_AnimationPoint animation0_points[4] = (animation_AnimationPoint[4]){
	{.brightness = 120, .time = 200},
	{.brightness = 120, .time = 200},
	{.brightness = 80, .time = 200},
	{.brightness = 0, .time = 200}
};
static animation_Animation animation0 = {
	.len = LENGTHOF(animation0_points),
	.points = (animation_AnimationPoint *)&animation0_points
};

bool animation_isBusy(animation_AnimationState *astate)
{
	return astate->run;
}

void animation_stop(animation_AnimationState *astate)
{
	printf("STOP\n");
	astate->stopSig = true;
}

void animation_startt(animation_AnimationState *astate)
{
	animation_start((animation_AnimationState *)astate, (animation_Animation *)&animation0);
}

void animation_start(animation_AnimationState *astate, animation_Animation *a)
{
	astate->cpoint = 0;
	astate->animation = (animation_Animation *)a;
	astate->run = true;
}

void animation_step(animation_AnimationState *astate)
{
	if (!astate->run) {
		return;
	}

	animation_Animation *const animation = astate->animation;
	if (animation == NULL) {
		return;
	}

	// Если выработали все точки - заканчиваем
	if ((astate->cpoint > animation->len) || astate->stopSig) {
		astate->animation = NULL;
		astate->run = false;
		return;
	}

	// Если мы здесь значит анимация должна выполняться
	// Смотрим если лед пришел в предыдущую точку то даем след задание

	if (led_isFree((led_LedController *)&led0)) {
		animation_AnimationPoint *const p = &astate->animation->points[astate->cpoint];
		astate->cpoint = astate->cpoint + 1;
		led_start((led_LedController *)&led0, p->brightness, p->time);
	}

	led_step((led_LedController *)&led0);
}

