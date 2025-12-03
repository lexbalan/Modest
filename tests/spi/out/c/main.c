
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static bool data_line;

static void clock_set(bool x) {
	//
}


static void data_set(bool x) {
	data_line = x;
}


static bool data_get(void) {
	return data_line;
}


static void delay(uint32_t x) {
}


static uint8_t spi_exchange(uint8_t x, uint8_t cpol) {
	const bool clkActive = cpol == 0;
	uint8_t retval = 0x0;
	uint8_t i = 7;
	while (true) {
		const bool b = (x & (0x1 << i)) != 0x0;
		data_set(b);
		delay(1);
		const bool p = data_get();
		retval = retval | ((uint8_t)p << i);
		clock_set(clkActive);
		delay(1);
		clock_set(!clkActive);
		if (i == 0) {
			break;
		}
		i = i - 1;
	}
	return retval;
}


int main(void) {
	const uint8_t x = spi_exchange(0x1D, 0);
	printf("x = 0x%02x\n", x);
	return 0;
}


