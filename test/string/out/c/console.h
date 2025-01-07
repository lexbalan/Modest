
#ifndef CONSOLE_H
#define CONSOLE_H

#include <stdint.h>
#include <stdbool.h>
#include "./utf.h"
#include "./console.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>













//$pragma do_not_include// for Int// for write()// for putchar()// for strlen, strcpy


void console_putchar8(char c);


void console_putchar16(uint16_t c);


void console_putchar32(uint32_t c);



void console_putchar_utf8(char c);


void console_putchar_utf16(uint16_t c);


void console_putchar_utf32(uint32_t c);


//
// puts
//


/*
// проблема тк puts уже определен в include ^^
public func puts(s: *Str8) -> Unit {
	puts8(s)
}
*/

void console_puts8(char *s);


void console_puts16(uint16_t *s);


void console_puts32(uint32_t *s);




void console_print(char *form, ...);




int32_t console_vfprint(int fd, char *form, va_list va);



int32_t console_vsprint(char *buf, char *form, va_list va);

















#endif /* CONSOLE_H */
