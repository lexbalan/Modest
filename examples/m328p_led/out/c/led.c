// out/c/led.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "led.h"



#define led_divider  256
void ledSet(uint32_t brightness);




void ledSet(uint32_t brightness)
{
	const uint32_t b = brightness / led_divider;
	//ledPwmSet(b)
	//printf("PWM = %d\n", b)
	bsp_tc1PWM_PB1((uint16_t)b);
}

void led_init()
{
	//bsp.initTC1_PWM()

	//bsp.tc1PWM_PB1(8)
	//bsp.tc1PWM_PB2(8)
}

bool led_isFree(led_LedController *led)
{
	return led->stepNo == led->stepEnd;
}

void led_reset(led_LedController *led)
{
	*led = (led_LedController){};
	ledSet(0);
}

void led_start(led_LedController *led, uint8_t brightness, uint32_t time)
{
	const int32_t diff = (int32_t)brightness * led_divider - (int32_t)led->brightness;
	led->step = diff / (int32_t)time;

	led->stepNo = 0;
	led->stepEnd = time;
	led->run = true;

	printf("start:\n");
	printf("brightness = %d\n", brightness);
	printf("step = %d\n", led->step);
	printf("stepEnd = %d\n", led->stepEnd);
}

void led_step(led_LedController *led)
{
	if (!led->run) {
		return;
	}

	if (led->stepNo == led->stepEnd) {
		led->run = false;
		return;
	}

	const uint32_t brightness = (uint32_t)((int32_t)led->brightness + led->step);
	led->brightness = brightness;

	printf("[%d]", led->stepNo);
	ledSet(brightness);

	led->stepNo = led->stepNo + 1;
}

