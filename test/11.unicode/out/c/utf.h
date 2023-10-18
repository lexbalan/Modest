
#ifndef UTF_H
#define UTF_H

#include <stdint.h>
#include <string.h>
#include <stdbool.h>



void utf32_to_utf8(uint32_t x, char *buf);

void utf8_puts(char *s);
void utf16_puts(uint16_t *s);
void utf32_puts(uint32_t *s);

void utf32_putchar(uint32_t c);

#endif  /* UTF_H */
