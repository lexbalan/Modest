// ./out/c/utf.h

#ifndef UTF_H
#define UTF_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>



uint8_t utf32_to_utf8(uint32_t c, char *buf);

uint8_t utf16_to_utf32(uint16_t *c, uint32_t *result);


void utf8_putchar(char c);
void utf16_putchar(uint16_t c);
void utf32_putchar(uint32_t c);

void utf8_puts(char *s);
void utf16_puts(uint16_t *s);
void utf32_puts(uint32_t *s);

#endif /* UTF_H */
