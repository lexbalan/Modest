
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "chacha20.h"
struct context {
	uint8_t (*key)[32];
	uint32_t nonce[3];
	uint32_t blockCounter;
	chacha20_Block block;
	uint32_t blockOffset;
};

static struct context init(uint8_t key[32], uint32_t (*_nonce)[3]) {
	uint32_t nonce[3];
	__builtin_memcpy(nonce, _nonce, sizeof(uint32_t [3]));
	return (struct context){
		.key = key,
		.nonce = {nonce[0], nonce[1], nonce[2]},
		.blockCounter = 0,
		.blockOffset = (uint32_t)sizeof(chacha20_Block)
	};
}

static void cipher(struct context *ctx, uint8_t data[], uint32_t len) {
	uint32_t i = 0;
	uint8_t (*bptr)[] = NULL;
	while (i < len) {
		if (ctx->blockOffset == (uint32_t)sizeof(chacha20_Block)) {
			chacha20_State state;
			chacha20_makeState((uint32_t *)(chacha20_Key *)ctx->key, (uint32_t)ctx->blockCounter, ctx->nonce, &state);
			__builtin_memcpy((uint32_t (*)[16 - 13])&state[13], (uint32_t (*)[3 - 0])&ctx->nonce[0], sizeof(uint32_t [16 - 13]));
			chacha20_chacha20Block(&state, &ctx->block);
			ctx->blockOffset = 0;
			bptr = (uint8_t (*)[])&ctx->block;
		}
		data[i] = data[i] ^ (*bptr)[ctx->blockOffset];
		ctx->blockOffset = ctx->blockOffset + 1;
		i = i + 1;
	}
}
static uint8_t testKey[32] = {0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F};
static uint8_t testNonce[12] = {0x0, 0x0, 0x0, 0x9, 0x0, 0x0, 0x0, 0x4A, 0x0, 0x0, 0x0, 0x0};
static uint32_t testNonce2[3] = {0x9, 0x4A, 0x0};
#define TEST_RESULT {0x10, 0xF1, 0xE7, 0xE4, 0xD1, 0x3B, 0x59, 0x15, 0x50, 0xF, 0xDD, 0x1F, 0xA3, 0x20, 0x71, 0xC4, 0xC7, 0xD1, 0xF4, 0xC7, 0x33, 0xC0, 0x68, 0x3, 0x4, 0x22, 0xAA, 0x9A, 0xC3, 0xD4, 0x6C, 0x4E, 0xD2, 0x82, 0x64, 0x46, 0x7, 0x9F, 0xAA, 0x9, 0x14, 0xC2, 0xD7, 0x5, 0xD9, 0x8B, 0x2, 0xA2, 0xB5, 0x12, 0x9C, 0xD1, 0xDE, 0x16, 0x4E, 0xB9, 0xCB, 0xD0, 0x83, 0xE8, 0xA2, 0x50, 0x3C, 0x4E}
#define LOREM1024 {'L', 'o', 'r', 'e', 'm', ' ', 'i', 'p', 's', 'u', 'm', ' ', 'd', 'o', 'l', 'o', 'r', ' ', 's', 'i', 't', ' ', 'a', 'm', 'e', 't', ',', ' ', 'c', 'o', 'n', 's', 'e', 'c', 't', 'e', 't', 'u', 'e', 'r', ' ', 'a', 'd', 'i', 'p', 'i', 's', 'c', 'i', 'n', 'g', ' ', 'e', 'l', 'i', 't', '.', ' ', 'A', 'e', 'n', 'e', 'a', 'n', ' ', 'c', 'o', 'm', 'm', 'o', 'd', 'o', ' ', 'l', 'i', 'g', 'u', 'l', 'a', ' ', 'e', 'g', 'e', 't', ' ', 'd', 'o', 'l', 'o', 'r', '.', ' ', 'A', 'e', 'n', 'e', 'a', 'n', ' ', 'm', 'a', 's', 's', 'a', '.', ' ', 'C', 'u', 'm', ' ', 's', 'o', 'c', 'i', 'i', 's', ' ', 'n', 'a', 't', 'o', 'q', 'u', 'e', ' ', 'p', 'e', 'n', 'a', 't', 'i', 'b', 'u', 's', ' ', 'e', 't', ' ', 'm', 'a', 'g', 'n', 'i', 's', ' ', 'd', 'i', 's', ' ', 'p', 'a', 'r', 't', 'u', 'r', 'i', 'e', 'n', 't', ' ', 'm', 'o', 'n', 't', 'e', 's', ',', ' ', 'n', 'a', 's', 'c', 'e', 't', 'u', 'r', ' ', 'r', 'i', 'd', 'i', 'c', 'u', 'l', 'u', 's', ' ', 'm', 'u', 's', '.', ' ', 'D', 'o', 'n', 'e', 'c', ' ', 'q', 'u', 'a', 'm', ' ', 'f', 'e', 'l', 'i', 's', ',', ' ', 'u', 'l', 't', 'r', 'i', 'c', 'i', 'e', 's', ' ', 'n', 'e', 'c', ',', ' ', 'p', 'e', 'l', 'l', 'e', 'n', 't', 'e', 's', 'q', 'u', 'e', ' ', 'e', 'u', ',', ' ', 'p', 'r', 'e', 't', 'i', 'u', 'm', ' ', 'q', 'u', 'i', 's', ',', ' ', 's', 'e', 'm', '.', ' ', 'N', 'u', 'l', 'l', 'a', ' ', 'c', 'o', 'n', 's', 'e', 'q', 'u', 'a', 't', ' ', 'm', 'a', 's', 's', 'a', ' ', 'q', 'u', 'i', 's', ' ', 'e', 'n', 'i', 'm', '.', ' ', 'D', 'o', 'n', 'e', 'c', ' ', 'p', 'e', 'd', 'e', ' ', 'j', 'u', 's', 't', 'o', ',', ' ', 'f', 'r', 'i', 'n', 'g', 'i', 'l', 'l', 'a', ' ', 'v', 'e', 'l', ',', ' ', 'a', 'l', 'i', 'q', 'u', 'e', 't', ' ', 'n', 'e', 'c', ',', ' ', 'v', 'u', 'l', 'p', 'u', 't', 'a', 't', 'e', ' ', 'e', 'g', 'e', 't', ',', ' ', 'a', 'r', 'c', 'u', '.', ' ', 'I', 'n', ' ', 'e', 'n', 'i', 'm', ' ', 'j', 'u', 's', 't', 'o', ',', ' ', 'r', 'h', 'o', 'n', 'c', 'u', 's', ' ', 'u', 't', ',', ' ', 'i', 'm', 'p', 'e', 'r', 'd', 'i', 'e', 't', ' ', 'a', ',', ' ', 'v', 'e', 'n', 'e', 'n', 'a', 't', 'i', 's', ' ', 'v', 'i', 't', 'a', 'e', ',', ' ', 'j', 'u', 's', 't', 'o', '.', ' ', 'N', 'u', 'l', 'l', 'a', 'm', ' ', 'd', 'i', 'c', 't', 'u', 'm', ' ', 'f', 'e', 'l', 'i', 's', ' ', 'e', 'u', ' ', 'p', 'e', 'd', 'e', ' ', 'm', 'o', 'l', 'l', 'i', 's', ' ', 'p', 'r', 'e', 't', 'i', 'u', 'm', '.', ' ', 'I', 'n', 't', 'e', 'g', 'e', 'r', ' ', 't', 'i', 'n', 'c', 'i', 'd', 'u', 'n', 't', '.', ' ', 'C', 'r', 'a', 's', ' ', 'd', 'a', 'p', 'i', 'b', 'u', 's', '.', ' ', 'V', 'i', 'v', 'a', 'm', 'u', 's', ' ', 'e', 'l', 'e', 'm', 'e', 'n', 't', 'u', 'm', ' ', 's', 'e', 'm', 'p', 'e', 'r', ' ', 'n', 'i', 's', 'i', '.', ' ', 'A', 'e', 'n', 'e', 'a', 'n', ' ', 'v', 'u', 'l', 'p', 'u', 't', 'a', 't', 'e', ' ', 'e', 'l', 'e', 'i', 'f', 'e', 'n', 'd', ' ', 't', 'e', 'l', 'l', 'u', 's', '.', ' ', 'A', 'e', 'n', 'e', 'a', 'n', ' ', 'l', 'e', 'o', ' ', 'l', 'i', 'g', 'u', 'l', 'a', ',', ' ', 'p', 'o', 'r', 't', 't', 'i', 't', 'o', 'r', ' ', 'e', 'u', ',', ' ', 'c', 'o', 'n', 's', 'e', 'q', 'u', 'a', 't', ' ', 'v', 'i', 't', 'a', 'e', ',', ' ', 'e', 'l', 'e', 'i', 'f', 'e', 'n', 'd', ' ', 'a', 'c', ',', ' ', 'e', 'n', 'i', 'm', '.', ' ', 'A', 'l', 'i', 'q', 'u', 'a', 'm', ' ', 'l', 'o', 'r', 'e', 'm', ' ', 'a', 'n', 't', 'e', ',', ' ', 'd', 'a', 'p', 'i', 'b', 'u', 's', ' ', 'i', 'n', ',', ' ', 'v', 'i', 'v', 'e', 'r', 'r', 'a', ' ', 'q', 'u', 'i', 's', ',', ' ', 'f', 'e', 'u', 'g', 'i', 'a', 't', ' ', 'a', ',', ' ', 't', 'e', 'l', 'l', 'u', 's', '.', ' ', 'P', 'h', 'a', 's', 'e', 'l', 'l', 'u', 's', ' ', 'v', 'i', 'v', 'e', 'r', 'r', 'a', ' ', 'n', 'u', 'l', 'l', 'a', ' ', 'u', 't', ' ', 'm', 'e', 't', 'u', 's', ' ', 'v', 'a', 'r', 'i', 'u', 's', ' ', 'l', 'a', 'o', 'r', 'e', 'e', 't', '.', ' ', 'Q', 'u', 'i', 's', 'q', 'u', 'e', ' ', 'r', 'u', 't', 'r', 'u', 'm', '.', ' ', 'A', 'e', 'n', 'e', 'a', 'n', ' ', 'i', 'm', 'p', 'e', 'r', 'd', 'i', 'e', 't', '.', ' ', 'E', 't', 'i', 'a', 'm', ' ', 'u', 'l', 't', 'r', 'i', 'c', 'i', 'e', 's', ' ', 'n', 'i', 's', 'i', ' ', 'v', 'e', 'l', ' ', 'a', 'u', 'g', 'u', 'e', '.', ' ', 'C', 'u', 'r', 'a', 'b', 'i', 't', 'u', 'r', ' ', 'u', 'l', 'l', 'a', 'm', 'c', 'o', 'r', 'p', 'e', 'r', ' ', 'u', 'l', 't', 'r', 'i', 'c', 'i', 'e', 's', ' ', 'n', 'i', 's', 'i', '.', ' ', 'N', 'a', 'm', ' ', 'e', 'g', 'e', 't', ' ', 'd', 'u', 'i', '.', ' ', 'E', 't', 'i', 'a', 'm', ' ', 'r', 'h', 'o', 'n', 'c', 'u', 's', '.', ' ', 'M', 'a', 'e', 'c', 'e', 'n', 'a', 's', ' ', 't', 'e', 'm', 'p', 'u', 's', ',', ' ', 't', 'e', 'l', 'l', 'u', 's', ' ', 'e', 'g', 'e', 't', ' ', 'c', 'o', 'n', 'd', 'i', 'm', 'e', 'n', 't', 'u', 'm', ' ', 'r', 'h', 'o', 'n', 'c', 'u', 's', ',', ' ', 's', 'e', 'm', ' ', 'q', 'u', 'a', 'm', ' ', 's', 'e', 'm', 'p', 'e', 'r', ' ', 'l', 'i', 'b', 'e', 'r', 'o', ',', ' ', 's', 'i', 't', ' ', 'a', 'm', 'e', 't', ' ', 'a', 'd', 'i', 'p', 'i', 's', 'c', 'i', 'n', 'g', ' ', 's', 'e', 'm', ' ', 'n', 'e', 'q', 'u', 'e', ' ', 's', 'e', 'd', ' ', 'i', 'p', 's', 'u', 'm', '.', ' ', 'N', 'a', 'm', ' ', 'q', 'u', 'a', 'm', ' ', 'n', 'u', 'n', 'c', ',', ' ', 'b', 'l', 'a', 'n', 'd', 'i', 't', ' ', 'v', 'e'}
static char xlorem1024[1024] = LOREM1024;
static bool test0(void);

int main(void) {
	printf("test ChaCha20 ");
	struct context ctx = init(testKey, &testNonce2);
	uint8_t (*const dptr)[] = (uint8_t (*)[])xlorem1024;
	cipher(&ctx, (uint8_t *)dptr, 1024);
	int32_t i = 0;
	struct context ctx2 = init(testKey, &testNonce2);
	cipher(&ctx2, (uint8_t *)dptr, 1024);
	i = 0;
	while (i < 1024) {
		printf("%c", xlorem1024[i]);
		i = i + 1;
	}
	if (!test0()) {
		printf("fail\n");
		return EXIT_FAILURE;
	}
	printf("success\n");
	return EXIT_SUCCESS;
}

static bool test0(void) {
	uint8_t key[32];
	__builtin_memcpy(&key, &testKey, sizeof(uint8_t [32]));
	uint32_t counter = 0x1;
	uint8_t nonce[12];
	__builtin_memcpy(&nonce, &testNonce, sizeof(uint8_t [12]));
	chacha20_State state;
	chacha20_makeState((uint32_t *)(chacha20_Key *)&key, counter, (uint32_t *)(uint32_t (*)[3])&nonce, &state);
	chacha20_Block block;
	chacha20_chacha20Block(&state, &block);
	uint8_t (*const bptr)[64] = (uint8_t (*)[64])&block;
	return __builtin_memcmp(bptr, &(const uint8_t [64])TEST_RESULT, sizeof(uint8_t [64])) == 0;
}

