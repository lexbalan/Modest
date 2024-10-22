// out/c/delay.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "delay.h"



static volatile uint32_t delayCounter = 0;

void delay_ms(uint32_t x)
{
	uint32_t t;
	t = x;
	while (t > 0) {
		while (delayCounter < 400) {
			delayCounter = delayCounter + 1;
		}
		t = t - 1;
	}
}

