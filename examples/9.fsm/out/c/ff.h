// lib/fastfood/main.hm

#ifndef FF_H
#define FF_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


#include "./delay.h"

void ff_memzero(void *mem, uint64_t len);
void ff_memcpy(void *dst, void *src, uint64_t len);
uint64_t ff_cstrlen(char *cstr);

void ff_printf(char *str, ...);

#endif /* FF_H */
