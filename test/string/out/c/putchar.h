
#ifndef PUTCHAR_H
#define PUTCHAR_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "./utf.h"
#include <stdio.h>
#include "./utf.h"




void putchar_putchar8(char c);
void putchar_putchar16(uint16_t c);
void putchar_putchar32(uint32_t c);
void putchar_utf8_putchar(char c);
void putchar_utf16_putchar(uint16_t c);
void putchar_utf32_putchar(uint32_t c);
void putchar_utf8_puts(char *s);
void putchar_utf16_puts(uint16_t *s);
void putchar_utf32_puts(uint32_t *s);

#endif /* PUTCHAR_H */
