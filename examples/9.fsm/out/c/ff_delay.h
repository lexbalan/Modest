// lib/lightfood/delay.hm

#ifndef FF_DELAY_H
#define FF_DELAY_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>



void delay_us(uint64_t us);
void delay_ms(uint64_t ms);
void delay_s(uint64_t s);

#endif /* FF_DELAY_H */
