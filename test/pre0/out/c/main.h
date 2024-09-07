
#ifndef MAIN_H
#define MAIN_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>

void printf(char *s, ...);

static inline
int div(int a, int b)
{
	return a / b;
}

#endif /* MAIN_H */
