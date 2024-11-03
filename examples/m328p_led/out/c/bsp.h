
#ifndef BSP_H
#define BSP_H

#include <stdint.h>
#include <stdbool.h>

#include "avr/m328p.h"

void bsp_initTC1_PWM();
void bsp_tc1PWM_PB1(uint16_t x);
void bsp_tc1PWM_PB2(uint16_t x);

#endif /* BSP_H */
