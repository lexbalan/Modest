// out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"




typedef uint8_t main_IO8;
typedef uint16_t main_IO16;


struct __attribute__((packed)) main_GPIO {
	main_IO8 in;
	main_IO8 dir;
	main_IO8 out;
};
#define main_sfrOffset  0x20


int16_t main()
{
	main_portB->dir = 0xFF;

	while (true) {
		main_portB->out = 0xFF;
		delay_ms(1000);

		main_portB->out = 0x00;
		delay_ms(1000);
	}

	return 0;
}

