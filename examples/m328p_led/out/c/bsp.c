// out/c/bsp.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "bsp.h"





void bsp_initTC1_PWM()
{
	// 10bit fast pwm (up to 0x03FF)
	const uint8_t a = 1 << m328p_cr1a_WGM10 | 1 << m328p_cr1a_WGM11;
	m328p_tc1->cr1a = a | 1 << m328p_cr1a_COM1A1 | 1 << m328p_cr1a_COM1B1;

	//tc1.ocr1a = 10
	//tc1.ocr1b = 10

	m328p_tc1->cr1b = 1 << m328p_cr1b_CS10 | 1 << m328p_cr1b_WGM12;
}

void bsp_tc1PWM_PB1(uint16_t x)
{
	m328p_tc1->ocr1a = x / 2;
}

void bsp_tc1PWM_PB2(uint16_t x)
{
	m328p_tc1->ocr1b = x / 2;
}

