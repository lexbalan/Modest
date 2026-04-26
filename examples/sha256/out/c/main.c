
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./sha256.h"
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
#define MAIN_INPUT_DATA_LENGTH 32
struct main_sha256_test_case {
	char inputData[MAIN_INPUT_DATA_LENGTH];
	uint32_t inputDataLen;

	sha256_Hash expectedResult;
};
static struct main_sha256_test_case main_test0 = (struct main_sha256_test_case){
	.inputData = "abc",
	.inputDataLen = 3,
	.expectedResult = {
		186, 120, 22, 191, 143, 1, 207, 234,
		65, 65, 64, 222, 93, 174, 34, 35,
		176, 3, 97, 163, 150, 23, 122, 156,
		180, 16, 255, 97, 242, 0, 21, 173
	}
};
static struct main_sha256_test_case main_test1 = (struct main_sha256_test_case){
	.inputData = "Hello World!",
	.inputDataLen = 12,
	.expectedResult = {
		127, 131, 177, 101, 127, 241, 252, 83,
		185, 45, 193, 129, 72, 161, 214, 93,
		252, 45, 75, 31, 163, 214, 119, 40,
		74, 221, 210, 0, 18, 109, 144, 105
	}
};
#define MAIN_TESTS {&main_test0, &main_test1}

static bool main_doTest(struct main_sha256_test_case *test) {
	sha256_Hash test_hash;
	uint8_t (*const main_msg)[] = (uint8_t (*)[])test->inputData;
	const uint32_t main_msgLen = test->inputDataLen;
	sha256_hash((uint8_t *)main_msg, main_msgLen, test_hash);
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
	uint32_t i = 0U;
	while (i < 2) {
		struct main_sha256_test_case *const main_test = ((struct main_sha256_test_case *const [2])MAIN_TESTS)[i];
		const bool main_testResult = main_doTest(main_test);
		char *res = "failed";
		if (main_testResult) {
			res = "passed";
		}
		printf("test #%i: %s\n", i, res);
		i = i + 1U;
	}
	return 0;
}

