
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
	return (struct context){.key = key, .nonce = {nonce[0], nonce[1], nonce[2]}, .blockCounter = 0, .blockOffset = (uint32_t)sizeof(chacha20_Block)};
}


static void cipher(struct context *ctx, uint8_t (*data)[], uint32_t len) {
	uint32_t i = 0;
	uint8_t (*bptr)[] = NULL;
	while (i < len) {
		if (ctx->blockOffset == (uint32_t)sizeof(chacha20_Block)) {
			chacha20_State state;
