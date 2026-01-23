
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static void xor_encrypter(uint8_t *buf, uint32_t buflen, uint8_t *key, uint32_t keylen) {
	uint32_t i = 0;
	uint32_t j = 0;
	while (i < buflen) {
		buf[i] = buf[i] ^ key[j];

		if (j < (keylen - 1)) {
			j = j + 1;
		} else {
			j = 0;
		}

		i = i + 1;
	}
}


//xor_encrypt = xor_encrypter
//xor_decrypt = xor_encrypter

#define MSG_LENGTH  12
#define KEY_LENGTH  3

static char test_msg[MSG_LENGTH + 1] = {'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '!'};
static char test_key[KEY_LENGTH + 1] = {'a', 'b', 'c'};

static void print_bytes(uint8_t *buf, uint32_t len) {
	uint32_t i = 0;
	while (i < len) {
		printf("0x%02X ", buf[i]);
		i = i + 1;
	}
	printf("\n");
}


int main(void) {
	printf("test xor encrypting\n");

	uint8_t *const tmsg = (uint8_t *)&test_msg;
	uint8_t *const tkey = (uint8_t *)&test_key;

	printf("before encrypt test_msg: \n");
	print_bytes(tmsg, MSG_LENGTH);

	// encrypt test data
	xor_encrypter(tmsg, MSG_LENGTH, tkey, KEY_LENGTH);

	printf("after encrypt test_msg: \n");
	print_bytes(tmsg, MSG_LENGTH);

	// decrypt test data
	xor_encrypter(tmsg, MSG_LENGTH, tkey, KEY_LENGTH);

	printf("after decrypt test_msg: \n");
	print_bytes(tmsg, MSG_LENGTH);

	return 0;
}


