
#include "sha256.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
struct context {
	uint8_t data[64];
	uint32_t datalen;
	uint64_t bitlen;
	uint32_t state[8];
};
//@inline
//func rotleft (a: Word32, b: Nat32) -> Word32 {
//	return (a << b) or (a >> (32 - b))
//}

__attribute__((always_inline))
static inline uint32_t rotright(uint32_t a, uint32_t b) {
	return a >> b | a << (32 - b);
}

__attribute__((always_inline))
static inline uint32_t ch(uint32_t x, uint32_t y, uint32_t z) {
	return (x & y) ^ (~x & z);
}

__attribute__((always_inline))
static inline uint32_t maj(uint32_t x, uint32_t y, uint32_t z) {
	return (x & y) ^ (x & z) ^ (y & z);
}

__attribute__((always_inline))
static inline uint32_t ep0(uint32_t x) {
	return rotright(x, 2) ^ rotright(x, 13) ^ rotright(x, 22);
}

__attribute__((always_inline))
static inline uint32_t ep1(uint32_t x) {
	return rotright(x, 6) ^ rotright(x, 11) ^ rotright(x, 25);
}

__attribute__((always_inline))
static inline uint32_t sig0(uint32_t x) {
	return rotright(x, 7) ^ rotright(x, 18) ^ x >> 3;
}

__attribute__((always_inline))
static inline uint32_t sig1(uint32_t x) {
	return rotright(x, 17) ^ rotright(x, 19) ^ x >> 10;
}
#define INITAL_STATE {0x6A09E667, 0xBB67AE85L, 0x3C6EF372, 0xA54FF53AL, 0x510E527F, 0x9B05688CL, 0x1F83D9AB, 0x5BE0CD19}

static void contextInit(struct context *ctx) {
	memcpy(&ctx->state, &(const uint32_t [8])INITAL_STATE, sizeof(uint32_t [8]));
}
#define K {0x428A2F98, 0x71374491, 0xB5C0FBCFL, 0xE9B5DBA5L, 0x3956C25B, 0x59F111F1, 0x923F82A4L, 0xAB1C5ED5L, 0xD807AA98L, 0x12835B01, 0x243185BE, 0x550C7DC3, 0x72BE5D74, 0x80DEB1FEL, 0x9BDC06A7L, 0xC19BF174L, 0xE49B69C1L, 0xEFBE4786L, 0xFC19DC6, 0x240CA1CC, 0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA, 0x983E5152L, 0xA831C66DL, 0xB00327C8L, 0xBF597FC7L, 0xC6E00BF3L, 0xD5A79147L, 0x6CA6351, 0x14292967, 0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13, 0x650A7354, 0x766A0ABB, 0x81C2C92EL, 0x92722C85L, 0xA2BFE8A1L, 0xA81A664BL, 0xC24B8B70L, 0xC76C51A3L, 0xD192E819L, 0xD6990624L, 0xF40E3585L, 0x106AA070, 0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5, 0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3, 0x748F82EE, 0x78A5636F, 0x84C87814L, 0x8CC70208L, 0x90BEFFFAL, 0xA4506CEBL, 0xBEF9A3F7L, 0xC67178F2L}

static void transform(struct context *ctx, uint8_t (*data)[]) {
	uint32_t m[64] = {0};
	uint32_t i = 0;
	uint32_t j = 0;
	while (i < 16) {
		const uint32_t x = /*$*/((uint32_t)(*data)[j + 0]) << 24 | /*$*/((uint32_t)(*data)[j + 1]) << 16 | /*$*/((uint32_t)(*data)[j + 2]) << 8 | /*$*/((uint32_t)(*data)[j + 3]) << 0;
		m[i] = x;
		j = j + 4;
		i = i + 1;
	}
	while (i < 64) {
		m[i] = sig1(m[i - 2]) + m[i - 7] + sig0(m[i - 15]) + m[i - 16];
		i = i + 1;
	}
	uint32_t x[8];
	memcpy(&x, &ctx->state, sizeof(uint32_t [8]));
	i = 0;
	while (i < 64) {
		const uint32_t t1 = x[7] + ep1(x[4]) + ch(x[4], x[5], x[6]) + ((const uint32_t [64])K)[i] + m[i];
		const uint32_t t2 = ep0(x[0]) + maj(x[0], x[1], x[2]);
		x[7] = x[6];
		x[6] = x[5];
		x[5] = x[4];
		x[4] = x[3] + t1;
		x[3] = x[2];
		x[2] = x[1];
		x[1] = x[0];
		x[0] = t1 + t2;
		i = i + 1;
	}
	i = 0;
	while (i < 8) {
		ctx->state[i] = ctx->state[i] + x[i];
		i = i + 1;
	}
}

static void update(struct context *ctx, uint8_t (*msg)[], uint32_t msgLen) {
	uint32_t i = 0;
	while (i < msgLen) {
		ctx->data[ctx->datalen] = (*msg)[i];
		ctx->datalen = ctx->datalen + 1;
		if (ctx->datalen == 64) {
			transform(ctx, &ctx->data);
			ctx->bitlen = ctx->bitlen + 512;
			ctx->datalen = 0;
		}
		i = i + 1;
	}
}

static void final(struct context *ctx, sha256_Hash *outHash) {
	uint32_t i = ctx->datalen;
	uint32_t n = 64;
	if (ctx->datalen < 56) {
		n = 56;
	}
	ctx->data[i] = 0x80;
	i = i + 1;
	memset(/*$*/((void *)&ctx->data[i]), 0, /*$*/((size_t)(n - i)));
	if (ctx->datalen >= 56) {
		transform(ctx, &ctx->data);
		memset(/*$*/((void *)&ctx->data), 0, 56);
	}
	ctx->bitlen = ctx->bitlen + /*$*/((uint64_t)ctx->datalen) * 8;
	ctx->data[63] = /*$*/((uint8_t)(ctx->bitlen >> 0));
	ctx->data[62] = /*$*/((uint8_t)(ctx->bitlen >> 8));
	ctx->data[61] = /*$*/((uint8_t)(ctx->bitlen >> 16));
	ctx->data[60] = /*$*/((uint8_t)(ctx->bitlen >> 24));
	ctx->data[59] = /*$*/((uint8_t)(ctx->bitlen >> 32));
	ctx->data[58] = /*$*/((uint8_t)(ctx->bitlen >> 40));
	ctx->data[57] = /*$*/((uint8_t)(ctx->bitlen >> 48));
	ctx->data[56] = /*$*/((uint8_t)(ctx->bitlen >> 56));
	transform(ctx, &ctx->data);
	i = 0;
	while (i < 4) {
		const uint32_t sh = 24 - i * 8;
		(*outHash)[i + 0] = /*$*/((uint8_t)(ctx->state[0] >> sh));
		(*outHash)[i + 4] = /*$*/((uint8_t)(ctx->state[1] >> sh));
		(*outHash)[i + 8] = /*$*/((uint8_t)(ctx->state[2] >> sh));
		(*outHash)[i + 12] = /*$*/((uint8_t)(ctx->state[3] >> sh));
		(*outHash)[i + 16] = /*$*/((uint8_t)(ctx->state[4] >> sh));
		(*outHash)[i + 20] = /*$*/((uint8_t)(ctx->state[5] >> sh));
		(*outHash)[i + 24] = /*$*/((uint8_t)(ctx->state[6] >> sh));
		(*outHash)[i + 28] = /*$*/((uint8_t)(ctx->state[7] >> sh));
		i = i + 1;
	}
}

void sha256_hash(uint8_t (*msg)[], uint32_t msgLen, sha256_Hash *outHash) {
	struct context ctx = (struct context){0};
	contextInit(&ctx);
	update(&ctx, msg, msgLen);
	final(&ctx, outHash);
}
