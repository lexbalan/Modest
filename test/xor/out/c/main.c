// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



static void xor_encrypter(uint8_t *buf, uint32_t buflen, uint8_t *key, uint32_t keylen)
{
	uint32_t i = 0;
	uint32_t j = 0;
	while (i < buflen) {
		buf[i] = buf[i] ^ key[j];

		if (j < keylen - 1) {
			j = j + 1;
		} else {
			j = 0;
		}

		i = i + 1;
	}
}


#define msg_length  12
#define key_length  3

static char test_msg[13] = "Hello World!";
static char test_key[4] = "abc";


static void print_bytes(uint8_t *buf, uint32_t len)
{
	uint32_t i = 0;
	while (i < len) {
		printf("0x%02X ", buf[i]);
		i = i + 1;
	}
	printf("\n");
}


int main()
{
	printf("test xor encrypting\n");

	uint8_t *tmsg = (uint8_t *)&test_msg[0];
	uint8_t *tkey = (uint8_t *)&test_key[0];

	printf("before encrypt test_msg: \n");
	print_bytes(tmsg, msg_length);

	//{'str': ' encrypt test data'}
	xor_encrypter(tmsg, msg_length, tkey, key_length);

	printf("after encrypt test_msg: \n");
	print_bytes(tmsg, msg_length);

	//{'str': ' decrypt test data'}
	xor_encrypter(tmsg, msg_length, tkey, key_length);

	printf("after decrypt test_msg: \n");
	print_bytes(tmsg, msg_length);

	return 0;
}

