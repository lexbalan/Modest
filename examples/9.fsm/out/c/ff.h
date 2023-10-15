
#ifndef FF_H
#define FF_H

#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// lib/fastfood/main.hm

void ff_memzero(void *mem, uint64_t len);
void ff_memcpy(void *dst, void *src, uint64_t len);
uint64_t ff_cstrlen(char *cstr);
void delay_us(uint64_t us);
void delay_ms(uint64_t ms);
void delay_s(uint64_t s);
void delay(uint64_t us);

void ff_print_hex_n32(uint32_t x, uint8_t a);
void ff_print_hex_n64(uint64_t x, uint8_t a);
void ff_print_hex_n128(unsigned __int128 x, uint8_t a);

#endif  /* FF_H */
