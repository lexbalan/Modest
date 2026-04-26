
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
#define MAIN_DATA_BUFFER_LENGTH 128
struct main_test {
	uint8_t data[MAIN_DATA_BUFFER_LENGTH];
	uint32_t len;
	uint32_t hash;
};
static struct main_test main_tests[3] = {
	(struct main_test){
		.data = {'1', '2', '3', '4', '5', '6', '7', '8', '9'},
		.len = 9,
		.hash = 3421780262U
	},
	(struct main_test){
		.data = {'T', 'h', 'e', ' ', 'q', 'u', 'i', 'c', 'k', ' ', 'b', 'r', 'o', 'w', 'n', ' ', 'f', 'o', 'x', ' ', 'j', 'u', 'm', 'p', 's', ' ', 'o', 'v', 'e', 'r', ' ', 't', 'h', 'e', ' ', 'l', 'a', 'z', 'y', ' ', 'd', 'o', 'g'},
		.len = 43,
		.hash = 1095738169U
	},
	(struct main_test){
		.data = {'T', 'e', 's', 't', ' ', 'v', 'e', 'c', 't', 'o', 'r', ' ', 'f', 'r', 'o', 'm', ' ', 'f', 'e', 'b', 'o', 'o', 't', 'i', '.', 'c', 'o', 'm'},
		.len = 28,
		.hash = 210206561U
	}
};

static bool main_runTest(struct main_test *test) {
	const uint32_t main_crc = crc32_run((uint8_t *)(uint8_t (*)[])&test->data, test->len);
	return main_crc == test->hash;
}

int main(void) {
	printf("test CRC32\n");
	crc32_init();
	bool success = true;
	uint32_t i = 0U;
	while (i < LENGTHOF(main_tests)) {
		if (!main_runTest(&main_tests[i])) {
			printf("test #%d failed\n", i);
			success = false;
		} else {
			printf("test #%d passed\n", i);
		}
		i = i + 1U;
	}
	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

