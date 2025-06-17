#ifndef MAIN_H
#define MAIN_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lib.h"
#include "fixed32.h"

//const yx = add(2, 2)

struct __attribute__((packed)) main_Point
{
	int32_t x;  // hi!
	int32_t y;  // lo?
};
typedef struct main_Point main_Point;

#define main_cq  "Hi!"

void main_f0();

void main_sbuf(void *p, uint32_t size);

//func ab_ret (a: Int32, b: Int32) -> record {a: Int32, b: Int32} {
//	return {a=a, b=b}
//}
//
//func ab_test () -> Unit {
//	let x = ab_ret(9, 11)
//	printf("x.a = %i\n", x.a)
//	printf("x.a = %i\n", x.b)
//}

int32_t main();

#endif /* MAIN_H */
