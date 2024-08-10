// ./out/c/sub.h

#ifndef SUB_H
#define SUB_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>

#include "./sub2.h"




typedef int32_t Int;
#define subName  "SubName"
#define default  (5)

void printf(char *s, ...);

int32_t div(int32_t a, int32_t b);
void printf(char *s, ...);
int32_t div(int32_t a, int32_t b)
{
	return a / b;
}

#endif /* SUB_H */
