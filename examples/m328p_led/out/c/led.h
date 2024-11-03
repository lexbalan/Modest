
#ifndef LED_H
#define LED_H

#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <stdio.h>
#include <stdio.h>

#include "bsp.h"

typedef struct led_LedController led_LedController; //

struct led_LedController {
	bool run;

	uint32_t brightness;
	uint32_t target_brightness;

	int32_t step;

	// когда stepNo == stepEnd еонтроллер чилит
	uint32_t stepNo;
	uint32_t stepEnd;
};
void led_init();
bool led_isFree(led_LedController *led);
void led_reset(led_LedController *led);
void led_start(led_LedController *led, uint8_t brightness, uint32_t time);
void led_step(led_LedController *led);

#endif /* LED_H */
