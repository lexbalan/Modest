
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "crc32.h"

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */


#define DATA_BUFFER_LENGTH  128


struct test {
	uint8_t data[DATA_BUFFER_LENGTH];
	uint32_t len;
	uint32_t hash;
};

static struct test tests[3] =
