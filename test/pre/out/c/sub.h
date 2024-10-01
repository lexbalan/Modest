// ./out/c/sub.h

#ifndef SUB_H
#define SUB_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "./sub2.h"

Int div(Int a, Int b);
#include "sub2.h"

typedef int32_t Int;
#define subName  "SubName"
#define default  (5)
static Int subCnt;
Int div(Int a, Int b)
{
	return a / b;
}

#endif /* SUB_H */
