// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define inputLength  32


struct main_SHA256_TestCase {
	char input_data[inputLength];
	uint32_t input_data_len;

	uint8_t expected_result[hashSize];
};
bool doTest(main_SHA256_TestCase *test);
int main();





static main_SHA256_TestCase test0 = {
	.input_data = "abc",
	.input_data_len = 3,

	.expected_result = {
		0xBA, 0x78, 0x16, 0xBF, 0x8F, 0x01, 0xCF, 0xEA,
		0x41, 0x41, 0x40, 0xDE, 0x5D, 0xAE, 0x22, 0x23,
		0xB0, 0x03, 0x61, 0xA3, 0x96, 0x17, 0x7A, 0x9C,
		0xB4, 0x10, 0xFF, 0x61, 0xF2, 0x00, 0x15, 0xAD
	}
};
static main_SHA256_TestCase test1 = {
	.input_data = "Hello World!",
	.input_data_len = 12,

	.expected_result = {
		0x7F, 0x83, 0xB1, 0x65, 0x7F, 0xF1, 0xFC, 0x53,
		0xB9, 0x2D, 0xC1, 0x81, 0x48, 0xA1, 0xD6, 0x5D,
		0xFC, 0x2D, 0x4B, 0x1F, 0xA3, 0xD6, 0x77, 0x28,
		0x4A, 0xDD, 0xD2, 0x00, 0x12, 0x6D, 0x90, 0x69
	}
};
static main_SHA256_TestCase *tests[2] = (main_SHA256_TestCase *[2]){(main_SHA256_TestCase *)&test0, (main_SHA256_TestCase *)&test1};

bool doTest(main_SHA256_TestCase *test)
{
	uint8_t test_hash[hashSize];
	uint8_t *const msg = (uint8_t *)(char *)&test->input_data;
	const uint32_t msg_len = test->input_data_len;
	sha256_hash(msg, msg_len, (uint8_t *)&test_hash);

	printf("'%s'", (char *)&test->input_data);
	printf(" -> ");

	int32_t i;
	i = 0;
	while (i < hashSize) {
		printf("%02X", test_hash[i]);
		i = i + 1;
	}

	printf("\n");

	const bool test_passed = memcmp(&test_hash, &test->expected_result, sizeof(sha256_Hash)) == 0;

	return test_passed;
}

int main()
{
	printf("test SHA256\n");

	int32_t i;
	i = 0;
	while (i < (int)(sizeof(tests) / sizeof(tests[0]))) {
		main_SHA256_TestCase *const test = tests[i];
		const bool test_result = doTest((main_SHA256_TestCase *)test);

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

