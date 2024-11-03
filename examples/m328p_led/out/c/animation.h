
#ifndef ANIMATION_H
#define ANIMATION_H

#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <stdio.h>
#include <stdio.h>
#include <stdio.h>

#include "led.h"

typedef struct animation_Color animation_Color; //
typedef struct animation_AnimationPoint animation_AnimationPoint; //
typedef struct animation_Animation animation_Animation; //
typedef struct animation_AnimationState animation_AnimationState; //

struct animation_AnimationState {
	bool run;
	animation_Animation *animation;
	uint32_t cpoint;
	bool stopSig;
};
bool animation_isBusy(animation_AnimationState *astate);
void animation_stop(animation_AnimationState *astate);
void animation_startt(animation_AnimationState *astate);
void animation_start(animation_AnimationState *astate, animation_Animation *a);
void animation_step(animation_AnimationState *astate);

#endif /* ANIMATION_H */
