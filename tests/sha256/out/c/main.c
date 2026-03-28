
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "./sha256.h"
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
#define INPUT_DATA_LENGTH 32
struct sha256_test_case {
	char inputData[INPUT_DATA_LENGTH];
	uint32_t inputDataLen;

	sha256_Hash expectedResult;
};
static struct sha256_test_case test0 = (struct sha256_test_case){
	.inputData = "abc",
	.inputDataLen = 3,
	.expectedResult = {186, 120, 22, 191, 143, 1, 207, 234, 65, 65, 64, 222, 93, 174, 34, 35, 176, 3, 97, 163, 150, 23, 122, 156, 180, 16, 255, 97, 242, 0, 21, 173}
};
static struct sha256_test_case test1 = (struct sha256_test_case){
	.inputData = "Hello World!",
	.inputDataLen = 12,
	.expectedResult = {127, 131, 177, 101, 127, 241, 252, 83, 185, 45, 193, 129, 72, 161, 214, 93, 252, 45, 75, 31, 163, 214, 119, 40, 74, 221, 210, 0, 18, 109, 144, 105}
};
#define TESTS {&test0, &test1}

static bool doTest(struct sha256_test_case *test) {
	sha256_Hash test_hash;
	uint8_t (*const msg)[] = (uint8_t (*)[])test->inputData;
	const uint32_t msgLen = test->inputDataLen;
	sha256_hash((uint8_t *)msg, msgLen, test_hash);
	printf("'%s'", test->inputData);
	printf(" -> ");
	uint32_t i = 0U;
	while (i < SHA256_HASH_SIZE) {
		printf("%02X", test_hash[i]);
		i = i + 1U;
	}
	printf("\n");
	return __builtin_memcmp(&test_hash, &test->expectedResult, sizeof(sha256_Hash)) == 0;
}

int main(void) {
	printf("test SHA256\n");
	bool success = true;
	uint32_t i = 0U;
	while (i < 2) {
		struct sha256_test_case *const test = ((struct sha256_test_case *const [2])TESTS)[i];
		const bool rc = doTest(test);
		success = success && rc;
		char *res = "failed";
		if (rc) {
			res = "passed";
		}
		printf("test #%i: %s\n", i, res);
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

