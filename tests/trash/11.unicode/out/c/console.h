
#if !defined(CONSOLE_H)
#define CONSOLE_H
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include "./utf.h"
#include "./console.h"
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
void console_putchar8(char c);
void console_putchar16(char16_t c);
void console_putchar32(char32_t c);
void console_putchar_utf8(char c);
void console_putchar_utf16(char16_t c);
void console_putchar_utf32(char32_t c);
//
// puts
//
void console_puts8(char *s);
void console_puts16(char16_t *s);
void console_puts32(char32_t *s);
void console_print(char *form, ...);
int32_t console_vfprint(int32_t fd, char *form, va_list va);
int32_t console_vsprint(char *buf, char *form, va_list va);
#endif

