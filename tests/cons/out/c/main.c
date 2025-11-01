// tests/cons/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



int main(void) {
	printf("test cons operation\n");

	/*let x0 = Int32 -1
	let x1 = Int64 -1

	let y0 = Nat64 x0
	let y1 = Nat64 x1

	printf("x0 = %llx\n", y0)
	printf("x1 = %llx\n", y1)*/


	const uint8_t a = 0xFF;
	const uint32_t b = (uint32_t)a;
	printf("a = %u\n", a);
	printf("b = %u\n", b);

	//	let c = Int32 a
	//	let d = Int32 Int8 -1
	//	let e = Int32 Int8 255

	//	printf("c = %i\n", c)
	//	printf("d = %i\n", d)
	//	printf("e = %i\n", e)

	return 0;
}


