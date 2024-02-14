// lib/fastfood/main.hm

#ifndef FF_MAIN_H
#define FF_MAIN_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>



void memzero(void *mem, uint64_t len);
void memcopy(void *dst, void *src, uint64_t len);
uint64_t cstrlen(char *cstr);

void ff_printf(char *str, ...);

#endif /* FF_MAIN_H */
