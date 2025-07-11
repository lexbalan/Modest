// utf.m
// algorithms from wikipedia
// (https://ru.wikipedia.org/wiki/UTF-16)

#ifndef UTF_H
#define UTF_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

uint8_t utf_utf32_to_utf8(uint32_t c, char *buf);
uint8_t utf_utf16_to_utf32(uint16_t *c, uint32_t *result);

#endif /* UTF_H */
