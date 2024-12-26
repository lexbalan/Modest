// ./out/c/delay.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "delay.h"



void delay_us(uint64_t us)
{
	clock_t start_time = clock();
	while (clock() < start_time + us) {
		// just waiting
	}
}


void delay_ms(uint64_t ms)
{
	delay_us(ms * 1000);
}


void delay_sec(uint64_t s)
{
	delay_us(s * 1000000);
}

