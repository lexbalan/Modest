// tests/sha256/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./sha256.h"

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */


#define INPUT_DATA_LENGTH  32

struct SHA256_TestCase {
	char inputData[INPUT_DATA_LENGTH];
	uint32_t inputDataLen;

	sha256_Hash expectedResult;
};
typedef struct SHA256_TestCase SHA256_TestCase;

static SHA256_TestCase test0 = {
	.inputData = "abc",
	.inputDataLen = 3,
	.expectedResult = {
		0xBA, 0x78, 0x16, 0xBF, 0x8F, 0x1, 0xCF, 0xEA,
		0x41, 0x41, 0x40, 0xDE, 0x5D, 0xAE, 0x22, 0x23,
		0xB0, 0x3, 0x61, 0xA3, 0x96, 0x17, 0x7A, 0x9C,
		0xB4, 0x10, 0xFF, 0x61, 0xF2, 0x0, 0x15, 0xAD
	}
};

static SHA256_TestCase test1 = {
	.inputData = "Hello World!",
	.inputDataLen = 12,
	.expectedResult = {
		0x7F, 0x83, 0xB1, 0x65, 0x7F, 0xF1, 0xFC, 0x53,
		0xB9, 0x2D, 0xC1, 0x81, 0x48, 0xA1, 0xD6, 0x5D,
		0xFC, 0x2D, 0x4B, 0x1F, 0xA3, 0xD6, 0x77, 0x28,
		0x4A, 0xDD, 0xD2, 0x0, 0x12, 0x6D, 0x90, 0x69
	}
};

#define TESTS  {&test0, &test1}

static bool doTest(SHA256_TestCase *test) {
	sha256_Hash test_hash;
	uint8_t *const msg = (uint8_t *)&test->inputData;
	const uint32_t msgLen = test->inputDataLen;

	sha256_hash(msg, msgLen, (uint8_t *)&test_hash);

	printf("'%s'", (char *)&test->inputData);
	printf(" -> ");

	uint32_t i = 0;
	while (i < SHA256_HASH_SIZE) {
		printf("%02X", test_hash[i]);
		i = i + 1;
	}

	printf("\n");

	return memcmp(&test_hash, &test->expectedResult, sizeof(sha256_Hash)) == 0;
}


int main() {
	printf("test SHA256\n");

	uint32_t i = 0;
	while (i < 2) {
		SHA256_TestCase *const test = ((SHA256_TestCase *[2])TESTS)[i];
		const bool testResult = doTest(test);

		char *res = "failed";
		if (testResult) {
			res = "passed";
		}

		printf("test #%i: %s\n", i, res);

		i = i + 1;
	}

	return 0;
}


