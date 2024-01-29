// test/sha256/main.cm

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include "./sha256.h"
#include <stdint.h>
#include <stdbool.h>





#define INPUT_LENGTH  32
#define OUTPUT_LENGTH  32

typedef struct {
    char input_data[INPUT_LENGTH];
    uint32_t input_data_len;

    uint8_t expected_result[OUTPUT_LENGTH];
} SHA256_TestCase;


static SHA256_TestCase test0 = {
    .input_data = {'a', 'b', 'c', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0'},
    .input_data_len = 3,

    .expected_result = {
        0xBA, 0x78, 0x16, 0xBF, 0x8F, 0x01, 0xCF, 0xEA,
        0x41, 0x41, 0x40, 0xDE, 0x5D, 0xAE, 0x22, 0x23,
        0xB0, 0x03, 0x61, 0xA3, 0x96, 0x17, 0x7A, 0x9C,
        0xB4, 0x10, 0xFF, 0x61, 0xF2, 0x00, 0x15, 0xAD
    }
};

static SHA256_TestCase test1 = {
    .input_data = {'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '!', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0'},
    .input_data_len = 12,

    .expected_result = {
        0x7F, 0x83, 0xB1, 0x65, 0x7F, 0xF1, 0xFC, 0x53,
        0xB9, 0x2D, 0xC1, 0x81, 0x48, 0xA1, 0xD6, 0x5D,
        0xFC, 0x2D, 0x4B, 0x1F, 0xA3, 0xD6, 0x77, 0x28,
        0x4A, 0xDD, 0xD2, 0x00, 0x12, 0x6D, 0x90, 0x69
    }
};


#define nTests  2
static SHA256_TestCase *sha256_tests[nTests] = {&test0, &test1};;


bool sha256_doTest(SHA256_TestCase *test)
{
    uint8_t test_hash[sha256HashSize];
    sha256_doHash((uint8_t *)(char *)&test->input_data, test->input_data_len, (uint8_t *)(uint8_t *)&test_hash);

    printf("'%s'", (char *)&test->input_data);
    printf(" -> ");

    int32_t i = 0;
    while (i < sha256HashSize) {
        printf("%02X", test_hash[i]);
        i = i + 1;
    }

    printf("\n");

    const bool test_passed = memcmp((void *)(uint8_t *)&test->expected_result, (void *)(uint8_t *)&test_hash, sha256HashSize) == 0;
    return test_passed;
}


int main()
{
    printf("test SHA256\n");

    int32_t i = 0;
    while (i < nTests) {
        SHA256_TestCase *const test = sha256_tests[i];
        const bool test_result = sha256_doTest(test);

        if (test_result) {
            printf("test #%d passed\n", i);
        } else {
            printf("test #%d failed\n", i);
        }

        i = i + 1;
    }

    return 0;
}

