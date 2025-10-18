// lightfood/console.m

#ifndef CONSOLE_H
#define CONSOLE_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include "./utf.h"
#include "./console.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>

#ifndef __STR_UNICODE__
#define __STR_UNICODE__
#define __STR8(x) x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x) __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#endif /* __STR_UNICODE__ */

void console_putchar8(char c);
void console_putchar16(uint16_t c);
void console_putchar32(uint32_t c);
void console_putchar_utf8(char c);
void console_putchar_utf16(uint16_t c);
void console_putchar_utf32(uint32_t c);
void console_puts8(char *s);
void console_puts16(uint16_t *s);
void console_puts32(uint32_t *s);
void console_print(char *form, ...);
int32_t console_vfprint(int32_t fd, char *form, va_list va);
int32_t console_vsprint(char *buf, char *form, va_list va);

#endif /* CONSOLE_H */
