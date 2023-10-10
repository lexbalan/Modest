
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include "./sha256.h"
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/sha256/main.cm



typedef uint8_t InputString[32];

typedef struct {
    InputString input;
    uint32_t input_len;
    uint8_t output[32];
} SHA256_TestData;


SHA256_TestData test0 = (SHA256_TestData){
    .input = {'a', 'b', 'c', '\x0'},
    .input_len = 3,

    .output = {0xBA, 0x78, 0x16, 0xBF, 0x8F, 0x01, 0xCF, 0xEA, 0x41, 0x41, 0x40, 0xDE, 0x5D, 0xAE, 0x22, 0x23, 0xB0, 0x03, 0x61, 0xA3, 0x96, 0x17, 0x7A, 0x9C, 0xB4, 0x10, 0xFF, 0x61, 0xF2, 0x00, 0x15, 0xAD}
};

SHA256_TestData test1 = (SHA256_TestData){
    .input = {'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '!', '\x0'},
    .input_len = 12,

    .output = {0x7F, 0x83, 0xB1, 0x65, 0x7F, 0xF1, 0xFC, 0x53, 0xB9, 0x2D, 0xC1, 0x81, 0x48, 0xA1, 0xD6, 0x5D, 0xFC, 0x2D, 0x4B, 0x1F, 0xA3, 0xD6, 0x77, 0x28, 0x4A, 0xDD, 0xD2, 0x00, 0x12, 0x6D, 0x90, 0x69}
};


#define nTests  2
SHA256_TestData *sha256_tests[nTests] = (SHA256_TestData *[nTests]){(SHA256_TestData *)&test0, (SHA256_TestData *)&test1};


bool sha256_doTest(SHA256_TestData *test)
{
    uint8_t test_hash[sha256HashSize];
    sha256_doHash((uint8_t *)&test->input[0], test->input_len, (uint8_t *)&test_hash[0]);


    printf("'%s'", &test->input[0]);

    printf(" -> ");

    int32_t i = (int32_t)0;
    while (i < sha256HashSize) {
        printf("%02X", test_hash[i]);
        i = i + 1;
    }

    printf("\n");


    const bool is_eq = memcmp((void *)&test->output[0], (void *)&test_hash[0], sha256HashSize) == 0;

    return is_eq;
}


uint8_t test_msg[13] = (uint8_t [13]){'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '!', '\x0'};
uint8_t test_hash[sha256HashSize];


int main(void)
{
    printf("test SHA256\n");

    int32_t i = (int32_t)0;
    while (i < nTests) {
        const bool test_result = sha256_doTest((SHA256_TestData *)sha256_tests[i]);

        if (test_result) {
            printf("test #%d passed\n", i);
        } else {
            printf("test #%d failed\n", i);
        }

        i = i + 1;
    }

    return 0;
}

