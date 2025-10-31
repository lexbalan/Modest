// out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"




int16_t main()
{
	m328p_portB->dir = 0xFF;

	while (true) {
		m328p_portB->out = 0xFF;
		delay_ms(1000);

		m328p_portB->out = 0x00;
		delay_ms(1000);
	}

	return 0;
}

