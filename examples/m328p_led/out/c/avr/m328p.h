
#ifndef M328P_H
#define M328P_H

#include <stdint.h>
#include <stdbool.h>

#include "avr.h"

typedef struct m328p_GPIO m328p_GPIO; //
typedef struct m328p_TC1 m328p_TC1; //


struct __attribute__((packed)) m328p_GPIO {
	avr_IO8 in;
	avr_IO8 dir;
	avr_IO8 out;
};



struct __attribute__((packed)) m328p_TC1 {
	uint8_t cr1a;
	uint8_t cr1b;
	uint8_t cr1c;
	uint8_t reserved0;
	uint16_t cnt1;
	uint16_t icr1;
	uint16_t ocr1a;
	uint16_t ocr1b;
};
#define m328p_cr1a_WGM10  0
#define m328p_cr1a_WGM11  1
#define m328p_cr1a_COM1B0  4
#define m328p_cr1a_COM1B1  5
#define m328p_cr1a_COM1A0  6
#define m328p_cr1a_COM1A1  7
#define m328p_cr1b_CS10  0
#define m328p_cr1b_CS11  1
#define m328p_cr1b_CS12  2
#define m328p_cr1b_WGM12  3
#define m328p_cr1b_WGM13  4
#define m328p_cr1b_ICES1  6
#define m328p_cr1b_ICNC1  7
#define m328p_portB  ((m328p_GPIO *)(avr_sfrOffset + 0x03))
#define m328p_portC  ((m328p_GPIO *)(avr_sfrOffset + 0x06))
#define m328p_portD  ((m328p_GPIO *)(avr_sfrOffset + 0x09))
#define m328p_tc1  ((m328p_TC1 *)(0 + 0x80))

#endif /* M328P_H */
