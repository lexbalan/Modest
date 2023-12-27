
#ifndef FF_H
#define FF_H

#include <stdint.h>
#include <stdbool.h>

// lib/fastfood/main.hm

void ff_memzero(void *mem, uint64_t len);
void ff_memcpy(void *dst, void *src, uint64_t len);
uint64_t ff_cstrlen(char *cstr);
void delay_us(uint64_t us);
void delay_ms(uint64_t ms);
void delay_s(uint64_t s);
void delay(uint64_t us);


void ff_printf(char *str, ...);

#endif  /* FF_H */
