// lightfood/delay.m

#include "delay.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <time.h>



void delay_us(uint64_t us) {
	const clock_t start_time = clock();
	while (clock() < start_time + us) {
		// just waiting
	}
}


void delay_ms(uint64_t ms) {
	delay_us(ms * 1000);
}


void delay_sec(uint64_t s) {
	delay_us(s * 1000000);
}


