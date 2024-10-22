// out/c/delay.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "delay.h"



static uint32_t delayCounter;

void delay_ms(uint32_t x)
{
	uint32_t t;
	t = x;
	while (t > 0) {
		delayCounter = 0;
		while (delayCounter < 400) {
			delayCounter = delayCounter + 1;
		}
		t = t - 1;
	}
}

