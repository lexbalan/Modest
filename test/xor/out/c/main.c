
#include <stdarg.h>
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
    uint32_t i = 0;
    uint32_t j = 0;
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

char test_msg[msg_length + 1] = {'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '!'};
char test_key[key_length + 1] = {'a', 'b', 'c'};


void print_bytes(uint8_t *buf, uint32_t len)
{
    uint32_t i = 0;
    while (i < len) {
        printf("0x%02X ", buf[i]);
        i = i + 1;
    }
    printf("\n");
}


int main(void)
{
    printf("test xor encrypting\n");

    uint8_t *const tmsg = (uint8_t *const)&test_msg[0];
    uint8_t *const tkey = (uint8_t *const)&test_key[0];

    printf("before encrypt test_msg: \n");
    print_bytes((uint8_t *)tmsg, msg_length);

    // encrypt test data
    xor_encrypter((uint8_t *)tmsg, msg_length, (uint8_t *)tkey, key_length);

    printf("after encrypt test_msg: \n");
    print_bytes((uint8_t *)tmsg, msg_length);

    // decrypt test data
    xor_encrypter((uint8_t *)tmsg, msg_length, (uint8_t *)tkey, key_length);

    printf("after decrypt test_msg: \n");
    print_bytes((uint8_t *)tmsg, msg_length);

    return 0;
}

