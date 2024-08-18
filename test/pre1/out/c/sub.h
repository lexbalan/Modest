
#ifndef SUB_H
#define SUB_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


#define name  "Name"
int32_t add(int32_t a, int32_t b);
int32_t sub(int32_t a, int32_t b);

static inline
int32_t mid(int32_t a, int32_t b)
{
	return (a + b) / 2;
}

#endif /* SUB_H */
