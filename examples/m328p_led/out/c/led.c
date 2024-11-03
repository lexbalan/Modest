// out/c/led.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "led.h"



#define led_divider  256
void ledSet(uint32_t brightness);
int32_t slope(uint32_t a, uint32_t b, uint32_t time);




void ledSet(uint32_t brightness)
{
	const uint32_t b = brightness / led_divider;
	//ledPwmSet(b)
	//printf("PWM = %d\n", b)

	// PB2 = RED
	bsp_tc1PWM_PB2((uint16_t)b);
}

int32_t slope(uint32_t a, uint32_t b, uint32_t time)
{
	const int32_t diff = (int32_t)b - (int32_t)a;
	const int32_t stepp = diff / (int32_t)time;
	return stepp;
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
	led->step = slope(led->brightness, (uint32_t)brightness * led_divider, time);

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

