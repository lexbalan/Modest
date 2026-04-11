
#include "delay.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
static volatile uint32_t delayCounter = 0U;

void delay_ms(uint32_t x) {
	volatile uint32_t t = x;
	while (t > 0U) {
		volatile uint32_t delayCounter = 0U;
		while (delayCounter < 380U) {
			delayCounter = delayCounter + 1U;
		}
		t = t - 1U;
	}
}

