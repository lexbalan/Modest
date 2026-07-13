
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

int main(void) {
	int32_t arr[10];
	int32_t *const p = (int32_t *)&arr[2];
	return 0;
}

