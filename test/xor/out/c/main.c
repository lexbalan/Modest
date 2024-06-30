// test/xor/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>





void xor_encrypter(uint8_t *buf, uint32_t buflen, uint8_t *key, uint32_t keylen)
{
	uint32_t i;
	i = 0;
	uint32_t j;
	j = 0;
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

//xor_encrypt = xor_encrypter
//xor_decrypt = xor_encrypter

#define msg_length  12
#define key_length  3

static char test_msg[msg_length + 1] = "Hello World!";
static char test_key[key_length + 1] = "abc";


void print_bytes(uint8_t *buf, uint32_t len)
{
	uint32_t i;
	i = 0;
	while (i < len) {
		printf("0x%02X ", buf[i]);
		i = i + 1;
	}
	printf("\n");
}


int main()
{
	printf("test xor encrypting\n");

	uint8_t *const tmsg = (uint8_t *)(char *)&test_msg;
	uint8_t *const tkey = (uint8_t *)(char *)&test_key;

	printf("before encrypt test_msg: \n");
	print_bytes(tmsg, msg_length);

	// encrypt test data
	xor_encrypter(tmsg, msg_length, tkey, key_length);

	printf("after encrypt test_msg: \n");
	print_bytes(tmsg, msg_length);

	// decrypt test data
	xor_encrypter(tmsg, msg_length, tkey, key_length);

	printf("after decrypt test_msg: \n");
	print_bytes(tmsg, msg_length);

	return 0;
}

