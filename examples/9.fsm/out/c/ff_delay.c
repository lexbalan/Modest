// lib/lightfood/delay.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <time.h>





void delay_us(uint64_t us)
{
	const clock_t start_time = clock();
	while (clock() < start_time + us) {
		// just waiting
	}
}


void delay(uint64_t us)
{
	delay_us(us);
}


void delay_ms(uint64_t ms)
{
	delay_us(ms * 1000);
}


void delay_s(uint64_t s)
{
	delay_ms(s * 1000);
}

