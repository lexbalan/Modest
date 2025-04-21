
#ifndef MAIN_H
#define MAIN_H

#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


struct Point {
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

#define cq  "Hi!"

static int32_t v0;
void main_f0();

void sbuf(void *p, uint32_t size);

int32_t ma();

int32_t main();

#endif /* MAIN_H */
