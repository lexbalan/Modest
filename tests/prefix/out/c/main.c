
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "lib.h"

#define HARD_CAST_UNSAFE(type, expr) (*(type*)(void*)&(expr))


int main(void) {
	struct nothing nothing;
	loo_foo((uint32_t)LOO_BAR);
	(void)loo_spam;
	return 0;
}


