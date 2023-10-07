
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/sha256/main.cm


void xor_encrypter(uint8_t *buf, uint32_t buflen, uint8_t *key, uint32_t keylen)
{
    uint32_t i = (uint32_t)0;
    uint32_t j = (uint32_t)0;
    while (i < buflen) {
        buf[i] = buf[i] ^ key[j];

        i = i + 1;

        if (j < keylen - 1) {
            j = j + 1;
        } else {
            j = 0;
        }
    }
}

//xor_encrypt = xor_encrypter
//xor_decrypt = xor_encrypter

#define msg_length  12
#define key_length  3

static uint8_t test_msg[msg_length + 1] = (uint8_t [msg_length + 1]){72U, 101U, 108U, 108U, 111U, 32U, 87U, 111U, 114U, 108U, 100U, 33U, 0U};
static uint8_t test_key[key_length + 1] = (uint8_t [key_length + 1]){97U, 98U, 99U, 0U};


void print_bytes(uint8_t *buf, uint32_t len)
{
    uint32_t i = (uint32_t)0;
    while (i < len) {
        printf("0x%02X ", buf[i]);
        i = i + 1;
    }
    printf("\n");
}


int main(void)
{
    printf("test xor encrypting\n");

    printf("before test_msg: \n");
    print_bytes((uint8_t *)&test_msg[0], msg_length);

    xor_encrypter((uint8_t *)&test_msg[0], msg_length, (uint8_t *)&test_key[0], key_length);

    printf("after test_msg: \n");
    print_bytes((uint8_t *)&test_msg[0], msg_length);

    xor_encrypter((uint8_t *)&test_msg[0], msg_length, (uint8_t *)&test_key[0], key_length);

    printf("after2 test_msg: \n");
    print_bytes((uint8_t *)&test_msg[0], msg_length);

    return 0;
}

