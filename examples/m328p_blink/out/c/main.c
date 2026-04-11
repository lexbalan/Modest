
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "delay.h"
#include "m328p.h"

int16_t main(void) {
	M328P_PORT_B->dir = 0xFF;
	while (true) {
		M328P_PORT_B->out = 0xFF;
		delay_ms(1000U);
		M328P_PORT_B->out = 0x0;
		delay_ms(1000U);
	}
	return 0;
}

