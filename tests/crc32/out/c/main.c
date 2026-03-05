
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


#define DATA_BUFFER_LENGTH 128


struct test {
	uint8_t data[DATA_BUFFER_LENGTH];
	uint32_t len;
	uint32_t hash;
};

static struct test tests[3] = /*mark=CA2*/{/*mark=CR5*/(struct test){.data = /*mark=CA1*/"123456789", .len = 9, .hash = 0xCBF43926L}, /*mark=CR5*/(struct test){.data = /*mark=CA1*/"The quick brown fox jumps over the lazy dog", .len = 43, .hash = 0x414FA339}, /*mark=CR5*/(struct test){.data = /*mark=CA1*/"Test vector from febooti.com", .len = 28, .hash = 0xC877F61}};

static bool runTest(struct test *test) {
	const uint32_t crc = crc32_run((uint8_t (*)[])&test->data, test->len);
	return crc == test->hash;
}


int main(void) {
	printf("test CRC32\n");
	crc32_init();

	bool success = true;

	uint32_t i = 0;
	while (i < LENGTHOF(tests)) {
		if (!runTest(&tests[i])) {
			printf("test #%d failed\n", i);
			success = false;
		} else {
			printf("test #%d passed\n", i);
		}
		i = i + 1;
	}

	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}

	printf("passed\n");
	return EXIT_SUCCESS;
}


