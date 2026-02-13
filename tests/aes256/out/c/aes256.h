
#ifndef AES256_H
#define AES256_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>


typedef uint8_t aes256_Result;

#define AES256_RESULT_SUCCESS  ((aes256_Result)0)
#define AES256_RESULT_ERROR  ((aes256_Result)1)


typedef struct aes256_key aes256_Key;
struct aes256_key {
	uint8_t raw[32];
};


typedef struct aes256_block aes256_Block;
struct aes256_block {
	uint8_t raw[16];
};


typedef struct aes256_context aes256_Context;
struct aes256_context {
	aes256_Key key;
	aes256_Key enckey;
	aes256_Key deckey;
};
aes256_Result aes256_init(aes256_Context *ctx, aes256_Key *key);
aes256_Result aes256_deinit(aes256_Context *ctx);
aes256_Result aes256_encrypt_ecb(aes256_Context *ctx, aes256_Block *buf);
aes256_Result aes256_decrypt_ecb(aes256_Context *ctx, aes256_Block *buf);

#endif /* AES256_H */
