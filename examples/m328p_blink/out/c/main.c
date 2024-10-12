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
void delay_ms(uint32_t ms);
int16_t main();
static uint32_t delay_counter;

void delay_ms(uint32_t ms)
{
	uint32_t t;
	t = ms;
	while (t > 0) {
		delay_counter = 0;
		while (delay_counter < 400) {
			delay_counter = delay_counter + 1;
		}
		t = t - 1;
	}
}

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

