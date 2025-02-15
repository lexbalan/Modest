
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <string.h>

#include "sha256.h"









struct sha256_Context {
	uint8_t data[64];
	uint32_t datalen;
	uint64_t bitlen;
	uint32_t state[8];
};
typedef struct sha256_Context sha256_Context;



static inline uint32_t sha256_rotleft(uint32_t a, uint32_t b)
{
	return a << b | a >> (32 - b);
}


static inline uint32_t sha256_rotright(uint32_t a, uint32_t b)
{
	return a >> b | a << (32 - b);
}


static inline uint32_t sha256_ch(uint32_t x, uint32_t y, uint32_t z)
{
	return x & y ^ ~x & z;
}


static inline uint32_t sha256_maj(uint32_t x, uint32_t y, uint32_t z)
{
	return x & y ^ x & z ^ y & z;
}


static inline uint32_t sha256_ep0(uint32_t x)
{
	return sha256_rotright(x, 2) ^ sha256_rotright(x, 13) ^ sha256_rotright(x, 22);
}


static inline uint32_t sha256_ep1(uint32_t x)
{
	return sha256_rotright(x, 6) ^ sha256_rotright(x, 11) ^ sha256_rotright(x, 25);
}


static inline uint32_t sha256_sig0(uint32_t x)
{
	return sha256_rotright(x, 7) ^ sha256_rotright(x, 18) ^ x >> 3;
}


static inline uint32_t sha256_sig1(uint32_t x)
{
	return sha256_rotright(x, 17) ^ sha256_rotright(x, 19) ^ x >> 10;
}



#define _sha256_initalState  { \
	0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A, \
	0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19 \
}
const uint32_t sha256_initalState[8] = _sha256_initalState;


static void sha256_contextInit(sha256_Context *ctx)
{
	memcpy(&ctx->state, &sha256_initalState, sizeof ctx->state);
}


#define _sha256_k  { \
	0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5, \
	0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5, \
	0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3, \
	0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174, \
	0xE49B69C1, 0xEFBE4786, 0x0FC19DC6, 0x240CA1CC, \
	0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA, \
	0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7, \
	0xC6E00BF3, 0xD5A79147, 0x06CA6351, 0x14292967, \
	0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13, \
	0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85, \
	0xA2BFE8A1, 0xA81A664B, 0xC24B8B70, 0xC76C51A3, \
	0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070, \
	0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5, \
	0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3, \
	0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208, \
	0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2 \
}
const uint32_t sha256_k[64] = _sha256_k;


static void sha256_transform(sha256_Context *ctx, uint8_t *data)
{
	uint32_t m[64];
	memset(&m, 0, sizeof m);

	uint32_t i = 0;
	uint32_t j = 0;

	while (i < 16) {
		const uint32_t x = (uint32_t)data[j + 0] << 24 | (uint32_t)data[j + 1] << 16 | (uint32_t)data[j + 2] << 8 | (uint32_t)data[j + 3] << 0;

		m[i] = x;
		j = j + 4;
		i = i + 1;
	}

	while (i < 64) {
		m[i] = (uint32_t)((uint32_t)sha256_sig1(m[i - 2]) + (uint32_t)m[i - 7] + (uint32_t)sha256_sig0(m[i - 15]) + (uint32_t)m[i - 16]);
		i = i + 1;
	}

	uint32_t x[8];
	memcpy(&x, &ctx->state, sizeof x);

	i = 0;
	while (i < 64) {
		const uint32_t t1 = (uint32_t)x[7] + (uint32_t)sha256_ep1(x[4]) + (uint32_t)sha256_ch(x[4], x[5], x[6]) + sha256_k[i] + (uint32_t)m[i];
		const uint32_t t2 = (uint32_t)sha256_ep0(x[0]) + (uint32_t)sha256_maj(x[0], x[1], x[2]);

		x[7] = x[6];
		x[6] = x[5];
		x[5] = x[4];
		x[4] = (uint32_t)((uint32_t)x[3] + t1);
		x[3] = x[2];
		x[2] = x[1];
		x[1] = x[0];
		x[0] = (uint32_t)(t1 + t2);

		i = i + 1;
	}

	i = 0;
	while (i < 8) {
		ctx->state[i] = (uint32_t)((uint32_t)ctx->state[i] + (uint32_t)x[i]);
		i = i + 1;
	}
}


static void sha256_update(sha256_Context *ctx, uint8_t *msg, uint32_t msgLen)
{
	uint32_t i = 0;
	while (i < msgLen) {
		ctx->data[ctx->datalen] = msg[i];
		ctx->datalen = ctx->datalen + 1;
		if (ctx->datalen == 64) {
			sha256_transform(ctx, (uint8_t *)&ctx->data);
			ctx->bitlen = ctx->bitlen + 512;
			ctx->datalen = 0;
		}
		i = i + 1;
	}
}


static void sha256_final(sha256_Context *ctx, uint8_t *outHash)
{
	uint32_t i = ctx->datalen;

	// Pad whatever data is left in the buffer.

	uint32_t n = 64;
	if (ctx->datalen < 56) {
		n = 56;
	}

	ctx->data[i] = 0x80;

	i = i + 1;

	memset(&ctx->data[i], 0, (size_t)(n - i));
	//ctx.data[i:n-i] = []

	if (ctx->datalen >= 56) {
		sha256_transform(ctx, (uint8_t *)&ctx->data);
		memset((uint8_t *)&ctx->data, 0, 56);
		//ctx.data[0:56] = []
	}

	// Append to the padding the total message's length in bits and transform.
	ctx->bitlen = ctx->bitlen + (uint64_t)ctx->datalen * 8;

	ctx->data[63] = (uint8_t)((uint64_t)ctx->bitlen >> 0);
	ctx->data[62] = (uint8_t)((uint64_t)ctx->bitlen >> 8);
	ctx->data[61] = (uint8_t)((uint64_t)ctx->bitlen >> 16);
	ctx->data[60] = (uint8_t)((uint64_t)ctx->bitlen >> 24);
	ctx->data[59] = (uint8_t)((uint64_t)ctx->bitlen >> 32);
	ctx->data[58] = (uint8_t)((uint64_t)ctx->bitlen >> 40);
	ctx->data[57] = (uint8_t)((uint64_t)ctx->bitlen >> 48);
	ctx->data[56] = (uint8_t)((uint64_t)ctx->bitlen >> 56);

	sha256_transform(ctx, (uint8_t *)&ctx->data);

	// Since this implementation uses little endian byte ordering
	// and SHA uses big endian, reverse all the bytes
	// when copying the final state to the output hash.

	i = 0;
	while (i < 4) {
		const uint32_t sh = 24 - i * 8;
		outHash[i + 0] = (uint8_t)(ctx->state[0] >> sh);
		outHash[i + 4] = (uint8_t)(ctx->state[1] >> sh);
		outHash[i + 8] = (uint8_t)(ctx->state[2] >> sh);
		outHash[i + 12] = (uint8_t)(ctx->state[3] >> sh);
		outHash[i + 16] = (uint8_t)(ctx->state[4] >> sh);
		outHash[i + 20] = (uint8_t)(ctx->state[5] >> sh);
		outHash[i + 24] = (uint8_t)(ctx->state[6] >> sh);
		outHash[i + 28] = (uint8_t)(ctx->state[7] >> sh);
		i = i + 1;
	}
}


void sha256_hash(uint8_t *msg, uint32_t msgLen, uint8_t *outHash)
{
	sha256_Context ctx = (sha256_Context){	};
	sha256_contextInit((sha256_Context *)&ctx);
	sha256_update((sha256_Context *)&ctx, msg, msgLen);
	sha256_final((sha256_Context *)&ctx, outHash);
}

