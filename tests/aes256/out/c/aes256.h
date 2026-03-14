
#if !defined(AES256_H)
#define AES256_H
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
// thx: https://github.com/ilvn/aes256/tree/main
typedef uint8_t aes256_Result;
#define AES256_RESULT_SUCCESS (/*$*/((aes256_Result)0))
#define AES256_RESULT_ERROR (/*$*/((aes256_Result)1))
typedef uint8_t aes256_Key[32];
typedef uint8_t aes256_Block[16];
typedef struct aes256_context aes256_Context;
struct aes256_context {
	aes256_Key key;
	aes256_Key enckey;
	aes256_Key deckey;
};
aes256_Result aes256_init(aes256_Context *ctx, aes256_Key *key);
aes256_Result aes256_encrypt_ecb(aes256_Context *ctx, aes256_Block *block);
aes256_Result aes256_decrypt_ecb(aes256_Context *ctx, aes256_Block *block);
aes256_Result aes256_deinit(aes256_Context *ctx);
#endif
