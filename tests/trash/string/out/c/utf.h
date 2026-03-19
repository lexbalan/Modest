
#if !defined(UTF_H)
#define UTF_H
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#if !defined(__STR_UNICODE__)
#define __STR_UNICODE__
typedef uint8_t char8_t;
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#define __STR8(x) x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x) __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#endif
uint8_t utf_utf32_to_utf8(char32_t c, char *buf);
uint8_t utf_utf16_to_utf32(char16_t *c, char32_t *result);
#endif

