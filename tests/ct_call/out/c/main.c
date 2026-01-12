
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static int32_t sum(int32_t a, int32_t b) {
	return a + b;
}


#define S  0

static void arr(int32_t *sret_) {
	memcpy(sret_, &((int32_t[3]){1, 2, 3}), sizeof(int32_t[3]));
}


#define A  {0}

int main(void) {
	printf("compile time call implementation test\n");
	return 0;
}


