
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

static struct context init(uint8_t (*key)[32], uint32_t (*_nonce)[3]) {
	uint32_t nonce[3];
	memcpy(nonce, _nonce, sizeof(uint32_t [3]));
	return /*mark=CR4*/(struct context){
		.key = key,
		.nonce = {nonce[0], nonce[1], nonce[2]},
		.blockCounter = 0,
		.blockOffset = (uint32_t)sizeof(chacha20_Block)
};
}


static void cipher(struct context *ctx, uint8_t (*data)[], uint32_t len) {
	uint32_t i = 0;
	uint8_t (*bptr)[] = NULL;
	while (i < len) {
		if (ctx->blockOffset == (uint32_t)sizeof(chacha20_Block)) {
			chacha20_State state;chacha20_makeState((chacha20_Key *)ctx->key, ctx->blockCounter, &ctx->nonce, &state);
			memcpy((uint32_t (*)[16 - 13])&state[13], (uint32_t (*)[3 - 0])&ctx->nonce[0], sizeof(uint32_t [16 - 13]));;

			chacha20_chacha20Block(&state, &ctx->block);
			ctx->blockOffset = 0;
			bptr = (uint8_t (*)[])&ctx->block;
		}

		(*data)[i] = (*data)[i] ^ (*bptr)[ctx->blockOffset];

		ctx->blockOffset = ctx->blockOffset + 1;
		i = i + 1;
	}
}


static uint8_t testKey[32] = /*mark=CA2*/{0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F};

static uint8_t testNonce[12] = /*mark=CA2*/{0x0, 0x0, 0x0, 0x9, 0x0, 0x0, 0x0, 0x4A, 0x0, 0x0, 0x0, 0x0};

static uint32_t testNonce2[3] = /*mark=CA2*/{0x9, 0x4A, 0x0};

#define TEST_RESULT  /*mark=CA2*/{0x10, 0xF1, 0xE7, 0xE4, 0xD1, 0x3B, 0x59, 0x15, 0x50, 0xF, 0xDD, 0x1F, 0xA3, 0x20, 0x71, 0xC4, 0xC7, 0xD1, 0xF4, 0xC7, 0x33, 0xC0, 0x68, 0x3, 0x4, 0x22, 0xAA, 0x9A, 0xC3, 0xD4, 0x6C, 0x4E, 0xD2, 0x82, 0x64, 0x46, 0x7, 0x9F, 0xAA, 0x9, 0x14, 0xC2, 0xD7, 0x5, 0xD9, 0x8B, 0x2, 0xA2, 0xB5, 0x12, 0x9C, 0xD1, 0xDE, 0x16, 0x4E, 0xB9, 0xCB, 0xD0, 0x83, 0xE8, 0xA2, 0x50, 0x3C, 0x4E}

#define LOREM1024  /*mark=CA1*/"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit ve"

static char xlorem1024[1024] = LOREM1024;


static bool test0(void);

int main(void) {
	printf("test ChaCha20 ");
	struct context ctx = init(&testKey, &testNonce2);
	uint8_t (*const dptr)[] = (uint8_t (*)[])xlorem1024;
	cipher(&ctx, dptr, 1024);

	int32_t i = 0;

	struct context ctx2 = init(&testKey, &testNonce2);
	cipher(&ctx2, dptr, 1024);

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
	uint8_t key[32];memcpy(&key, &testKey, sizeof(uint8_t [32]));;
	uint32_t counter = 0x1;
	uint8_t nonce[12];memcpy(&nonce, &testNonce, sizeof(uint8_t [12]));;
	chacha20_State state;chacha20_makeState((chacha20_Key *)&key, counter, (uint32_t (*)[3])&nonce, &state);
	chacha20_Block block;chacha20_chacha20Block(&state, &block);

	uint8_t (*const bptr)[64] = (uint8_t (*)[64])&block;

	return memcmp(&*bptr, /*mark=?*/&(uint8_t [64])TEST_RESULT, sizeof(uint8_t [64])) == 0;
}


