// ./out/c/ff_delay.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "delay.h"





void delay_delay_us(uint64_t us)
{
	const clock_t start_time = clock();
	while (clock() < start_time + us) {
		// just waiting
	}
}

void delay_delay(uint64_t us)
{
	delay_delay_us(us);
}

void delay_delay_ms(uint64_t ms)
{
	delay_delay_us(ms * 1000);
}

void delay_delay_s(uint64_t s)
{
	delay_delay_ms(s * 1000);
}

