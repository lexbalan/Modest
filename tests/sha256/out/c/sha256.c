
#include "sha256.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
struct sha256_context {
	uint8_t data[64];
	uint32_t datalen;
	uint64_t bitlen;
	uint32_t state[8];
};
//@inline
//func rotleft (a: Word32, b: Nat32) -> Word32 {
//	return (a << b) | (a >> (32 - b))
//}

__attribute__((always_inline))
static inline uint32_t sha256_rotright(uint32_t a, uint32_t b) {
	return a >> b | a << (32U - b);
}

__attribute__((always_inline))
static inline uint32_t sha256_ch(uint32_t x, uint32_t y, uint32_t z) {
	return (x & y) ^ (~x & z);
}

__attribute__((always_inline))
static inline uint32_t sha256_maj(uint32_t x, uint32_t y, uint32_t z) {
	return (x & y) ^ (x & z) ^ (y & z);
}

__attribute__((always_inline))
static inline uint32_t sha256_ep0(uint32_t x) {
	return sha256_rotright(x, 2U) ^ sha256_rotright(x, 13U) ^ sha256_rotright(x, 22U);
}

__attribute__((always_inline))
static inline uint32_t sha256_ep1(uint32_t x) {
	return sha256_rotright(x, 6U) ^ sha256_rotright(x, 11U) ^ sha256_rotright(x, 25U);
}

__attribute__((always_inline))
static inline uint32_t sha256_sig0(uint32_t x) {
	return sha256_rotright(x, 7U) ^ sha256_rotright(x, 18U) ^ x >> 3;
}

__attribute__((always_inline))
static inline uint32_t sha256_sig1(uint32_t x) {
	return sha256_rotright(x, 17U) ^ sha256_rotright(x, 19U) ^ x >> 10;
}
#define SHA256_INITAL_STATE { \
	1779033703U, 3144134277U, 1013904242U, 2773480762U, \
	1359893119U, 2600822924U, 528734635U, 1541459225U \
}

static void sha256_contextInit(struct sha256_context *ctx) {
	__builtin_memcpy(&ctx->state, &(const int32_t [8])SHA256_INITAL_STATE, sizeof(uint32_t [8]));
}
#define SHA256_K { \
	0x428A2F98U, 0x71374491U, 0xB5C0FBCFU, 0xE9B5DBA5U, \
	0x3956C25BU, 0x59F111F1U, 0x923F82A4U, 0xAB1C5ED5U, \
	0xD807AA98U, 0x12835B01U, 0x243185BEU, 0x550C7DC3U, \
	0x72BE5D74U, 0x80DEB1FEU, 0x9BDC06A7U, 0xC19BF174U, \
	0xE49B69C1U, 0xEFBE4786U, 0xFC19DC6U, 0x240CA1CCU, \
	0x2DE92C6FU, 0x4A7484AAU, 0x5CB0A9DCU, 0x76F988DAU, \
	0x983E5152U, 0xA831C66DU, 0xB00327C8U, 0xBF597FC7U, \
	0xC6E00BF3U, 0xD5A79147U, 0x6CA6351U, 0x14292967U, \
	0x27B70A85U, 0x2E1B2138U, 0x4D2C6DFCU, 0x53380D13U, \
	0x650A7354U, 0x766A0ABBU, 0x81C2C92EU, 0x92722C85U, \
	0xA2BFE8A1U, 0xA81A664BU, 0xC24B8B70U, 0xC76C51A3U, \
	0xD192E819U, 0xD6990624U, 0xF40E3585U, 0x106AA070U, \
	0x19A4C116U, 0x1E376C08U, 0x2748774CU, 0x34B0BCB5U, \
	0x391C0CB3U, 0x4ED8AA4AU, 0x5B9CCA4FU, 0x682E6FF3U, \
	0x748F82EEU, 0x78A5636FU, 0x84C87814U, 0x8CC70208U, \
	0x90BEFFFAU, 0xA4506CEBU, 0xBEF9A3F7U, 0xC67178F2U \
}

static void sha256_transform(struct sha256_context *ctx, uint8_t data[]) {
	uint32_t m[64] = {0};
	uint32_t i = 0U;
	uint32_t j = 0U;
	while (i < 16U) {
		const uint32_t sha256_x = (uint32_t)data[j + 0U] << 24 | (uint32_t)data[j + 1U] << 16 | (uint32_t)data[j + 2U] << 8 | (uint32_t)data[j + 3U] << 0;
		m[i] = sha256_x;
		j = j + 4U;
		i = i + 1U;
	}
	while (i < 64U) {
		m[i] = sha256_sig1(m[i - 2U]) + m[i - 7U] + sha256_sig0(m[i - 15U]) + m[i - 16U];
		i = i + 1U;
	}
	uint32_t x[8];
	__builtin_memcpy(&x, &ctx->state, sizeof(uint32_t [8]));
	i = 0U;
	while (i < 64U) {
		const uint32_t sha256_t1 = x[7] + sha256_ep1(x[4]) + sha256_ch(x[4], x[5], x[6]) + ((const uint32_t [64])SHA256_K)[i] + m[i];
		const uint32_t sha256_t2 = sha256_ep0(x[0]) + sha256_maj(x[0], x[1], x[2]);
		x[7] = x[6];
		x[6] = x[5];
		x[5] = x[4];
		x[4] = x[3] + sha256_t1;
		x[3] = x[2];
		x[2] = x[1];
		x[1] = x[0];
		x[0] = sha256_t1 + sha256_t2;
		i = i + 1U;
	}
	i = 0U;
	while (i < 8U) {
		ctx->state[i] = ctx->state[i] + x[i];
		i = i + 1U;
	}
}

static void sha256_update(struct sha256_context *ctx, uint8_t msg[], uint32_t msgLen) {
	uint32_t i = 0U;
	while (i < msgLen) {
		ctx->data[ctx->datalen] = msg[i];
		ctx->datalen = ctx->datalen + 1U;
		if (ctx->datalen == 64U) {
			sha256_transform(ctx, (uint8_t *)&ctx->data);
			ctx->bitlen = ctx->bitlen + 512ULL;
			ctx->datalen = 0U;
		}
		i = i + 1U;
	}
}

static void sha256_final(struct sha256_context *ctx, uint8_t outHash[SHA256_HASH_SIZE]) {
	uint32_t i = ctx->datalen;
	uint32_t n = 64U;
	if (ctx->datalen < 56U) {
		n = 56U;
	}
	ctx->data[i] = 0x80;
	i = i + 1U;
	memset(&ctx->data[i], 0, (size_t)(n - i));
	if (ctx->datalen >= 56U) {
		sha256_transform(ctx, (uint8_t *)&ctx->data);
		memset(&ctx->data, 0, 56ULL);
	}
	ctx->bitlen = ctx->bitlen + (uint64_t)ctx->datalen * 8ULL;
	ctx->data[63] = (uint8_t)(ctx->bitlen >> 0);
	ctx->data[62] = (uint8_t)(ctx->bitlen >> 8);
	ctx->data[61] = (uint8_t)(ctx->bitlen >> 16);
	ctx->data[60] = (uint8_t)(ctx->bitlen >> 24);
	ctx->data[59] = (uint8_t)(ctx->bitlen >> 32);
	ctx->data[58] = (uint8_t)(ctx->bitlen >> 40);
	ctx->data[57] = (uint8_t)(ctx->bitlen >> 48);
	ctx->data[56] = (uint8_t)(ctx->bitlen >> 56);
	sha256_transform(ctx, (uint8_t *)&ctx->data);
	i = 0U;
	while (i < 4U) {
		const uint32_t sha256_sh = 24U - i * 8U;
		outHash[i + 0U] = ctx->state[0] >> sha256_sh;
		outHash[i + 4U] = ctx->state[1] >> sha256_sh;
		outHash[i + 8U] = ctx->state[2] >> sha256_sh;
		outHash[i + 12U] = ctx->state[3] >> sha256_sh;
		outHash[i + 16U] = ctx->state[4] >> sha256_sh;
		outHash[i + 20U] = ctx->state[5] >> sha256_sh;
		outHash[i + 24U] = ctx->state[6] >> sha256_sh;
		outHash[i + 28U] = ctx->state[7] >> sha256_sh;
		i = i + 1U;
	}
}

void sha256_hash(uint8_t msg[], uint32_t msgLen, uint8_t outHash[SHA256_HASH_SIZE]) {
	struct sha256_context ctx = (struct sha256_context){0};
	sha256_contextInit(&ctx);
	sha256_update(&ctx, (uint8_t *)msg, msgLen);
	sha256_final(&ctx, (uint8_t *)outHash);
}

