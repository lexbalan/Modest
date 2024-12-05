
#ifndef DELAY_H
#define DELAY_H

#include <stdint.h>
#include <stdbool.h>
#include <time.h>
#include <time.h>


void delay_us(uint64_t us);
void delay_ms(uint64_t ms);
void delay_sec(uint64_t s);

#endif /* DELAY_H */
