
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "crc32.h"
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
#define DATA_BUFFER_LENGTH 128
struct test {
	uint8_t data[DATA_BUFFER_LENGTH];
	uint32_t len;
	uint32_t hash;
};
static struct test tests[3] = {
	{
		.data = {'1', '2', '3', '4', '5', '6', '7', '8', '9'},
		.len = 9,
		.hash = 0xCBF43926UL
	},
	{
		.data = {'T', 'h', 'e', ' ', 'q', 'u', 'i', 'c', 'k', ' ', 'b', 'r', 'o', 'w', 'n', ' ', 'f', 'o', 'x', ' ', 'j', 'u', 'm', 'p', 's', ' ', 'o', 'v', 'e', 'r', ' ', 't', 'h', 'e', ' ', 'l', 'a', 'z', 'y', ' ', 'd', 'o', 'g'},
		.len = 43,
		.hash = 0x414FA339
	},
	{
		.data = {'T', 'e', 's', 't', ' ', 'v', 'e', 'c', 't', 'o', 'r', ' ', 'f', 'r', 'o', 'm', ' ', 'f', 'e', 'b', 'o', 'o', 't', 'i', '.', 'c', 'o', 'm'},
		.len = 28,
		.hash = 0x0C877F61
	}
};

static bool runTest(struct test *test) {
	const uint32_t crc = crc32_run((uint8_t *)(uint8_t (*)[])&test->data, test->len);
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

