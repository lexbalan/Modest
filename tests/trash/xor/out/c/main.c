
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

static void main_xor_encrypter(uint8_t buf[], uint32_t buflen, uint8_t key[], uint32_t keylen) {
	uint32_t i = 0U;
	uint32_t j = 0U;
	while (i < buflen) {
		buf[i] = buf[i] ^ key[j];
		if (j < keylen - 1U) {
			j = j + 1U;
		} else {
			j = 0U;
		}
		i = i + 1U;
	}
}
//xor_encrypt = xor_encrypter
//xor_decrypt = xor_encrypter
#define MAIN_MSG_LENGTH 12
#define MAIN_KEY_LENGTH 3
static char main_test_msg[MAIN_MSG_LENGTH + 1] = {'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '!'};
static char main_test_key[MAIN_KEY_LENGTH + 1] = {'a', 'b', 'c'};

static void main_print_bytes(uint8_t buf[], uint32_t len) {
	uint32_t i = 0U;
	while (i < len) {
		printf("0x%02X ", buf[i]);
		i = i + 1U;
	}
	printf("\n");
}

int main(void) {
	printf("test ^ encrypting\n");
	uint8_t (*const main_tmsg)[] = (uint8_t (*)[])main_test_msg;
	uint8_t (*const main_tkey)[] = (uint8_t (*)[])main_test_key;
	printf("before encrypt test_msg: \n");
	main_print_bytes((uint8_t *)main_tmsg, MAIN_MSG_LENGTH);
	main_xor_encrypter((uint8_t *)main_tmsg, MAIN_MSG_LENGTH, (uint8_t *)main_tkey, MAIN_KEY_LENGTH);
	printf("after encrypt test_msg: \n");
	main_print_bytes((uint8_t *)main_tmsg, MAIN_MSG_LENGTH);
	main_xor_encrypter((uint8_t *)main_tmsg, MAIN_MSG_LENGTH, (uint8_t *)main_tkey, MAIN_KEY_LENGTH);
	printf("after decrypt test_msg: \n");
	main_print_bytes((uint8_t *)main_tmsg, MAIN_MSG_LENGTH);
	return 0;
}

