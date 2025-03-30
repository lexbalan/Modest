
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./sha256.h"

#include "main.h"

#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */


#define inputDataLength  32

struct SHA256_TestCase {
	char input_data[inputDataLength];
	uint32_t input_data_len;

	sha256_Hash expected_result;
};
typedef struct SHA256_TestCase SHA256_TestCase;

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

#define tests  {&test0, (SHA256_TestCase *)&test1}

static bool doTest(SHA256_TestCase *test)
{
	sha256_Hash test_hash;
	uint8_t *const msg = (uint8_t *)&test->input_data;
	const uint32_t msg_len = test->input_data_len;

	sha256_hash(msg, msg_len, &test_hash);

	printf("'%s'", &test->input_data);
	printf(" -> ");

	int32_t i = 0;
	while (i < sha256_hashSize) {
		printf("%02X", test_hash[i]);
		i = i + 1;
	}

	printf("\n");

	return memcmp(&test_hash, &test->expected_result, sizeof(sha256_Hash)) == 0;
}

int main()
{
	printf("test SHA256\n");

	int32_t i = 0;
	while (i < (int)2) {
		SHA256_TestCase *const test = ((SHA256_TestCase *[2])tests)[i];
		const bool test_result = doTest((SHA256_TestCase *)test);

		char *res = "failed";
		if (test_result) {
			res = "passed";
		}

		printf("test #%i: %s\n", i, res);

		i = i + 1;
	}

	return 0;
}

