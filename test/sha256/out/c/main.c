// test/sha256/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include "./sha256.h"






#define inputLength  32
#define outputLength  sha256HashSize


typedef struct {
	char input_data[inputLength];
	uint32_t input_data_len;

	uint8_t expected_result[outputLength];
} SHA256_TestCase;


static SHA256_TestCase test0 = {
	.input_data = "abc",
	.input_data_len = 3,

	.expected_result = {
		0xBA, 0x78, 0x16, 0xBF, 0x8F, 0x01, 0xCF, 0xEA,
		0x41, 0x41, 0x40, 0xDE, 0x5D, 0xAE, 0x22, 0x23,
		0xB0, 0x03, 0x61, 0xA3, 0x96, 0x17, 0x7A, 0x9C,
		0xB4, 0x10, 0xFF, 0x61, 0xF2, 0x00, 0x15, 0xAD
	}
};

static SHA256_TestCase test1 = {
	.input_data = "Hello World!",
	.input_data_len = 12,

	.expected_result = {
		0x7F, 0x83, 0xB1, 0x65, 0x7F, 0xF1, 0xFC, 0x53,
		0xB9, 0x2D, 0xC1, 0x81, 0x48, 0xA1, 0xD6, 0x5D,
		0xFC, 0x2D, 0x4B, 0x1F, 0xA3, 0xD6, 0x77, 0x28,
		0x4A, 0xDD, 0xD2, 0x00, 0x12, 0x6D, 0x90, 0x69
	}
};


//var sha256_tests: []*SHA256_TestCase = [&test0, &test1]
static SHA256_TestCase *sha256_tests[2] = {&test0, &test1};


bool sha256_doTest(SHA256_TestCase *test)
{
	uint8_t test_hash[sha256HashSize];
	uint8_t *const msg = (uint8_t *)(char *)&test->input_data;
	const uint32_t msg_len = test->input_data_len;
	sha256_doHash(msg, msg_len, (uint8_t *)&test_hash);

	printf("'%s'", (char *)&test->input_data);
	printf(" -> ");

	int32_t i;
	i = 0;
	while (i < sha256HashSize) {
		printf("%02X", test_hash[i]);
		i = i + 1;
	}

	printf("\n");

	const bool test_passed = /*eq*/memcmp(&test_hash, &test->expected_result, sizeof test_hash) == 0;

	return test_passed;
}


int main()
{
	printf("test SHA256\n");

	int32_t i;
	i = 0;
	while (i < (int)(sizeof(sha256_tests) / sizeof(sha256_tests[0]))) {
		SHA256_TestCase *const test = sha256_tests[i];
		const bool test_result = sha256_doTest(test);

		char *res;
		res = "failed";
		if (test_result) {
			res = "passed";
		}

		printf("test #%i: %s\n", i, res);

		i = i + 1;
	}

	return 0;
}

