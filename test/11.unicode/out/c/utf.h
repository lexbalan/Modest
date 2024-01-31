// ./out/c/utf.h


#ifndef UTF_H
#define UTF_H

#include <string.h>
#include <stdint.h>
#include <stdbool.h>


void utf32_to_utf8(uint32_t x, char *buf);

uint8_t utf16_to_utf32(uint16_t *c, uint32_t *result);


void utf8_puts(char *s);
void utf16_puts(uint16_t *s);
void utf32_puts(uint32_t *s);

void utf32_putchar(uint32_t c);

#endif  /* UTF_H */
