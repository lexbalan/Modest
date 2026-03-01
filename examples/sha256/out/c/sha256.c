
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
	return (a >> b) | (a << (32 - b));
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
	return rotright(x, 7) ^ rotright(x, 18) ^ (x >> 3);
}


__attribute__((always_inline))
static inline uint32_t sig1(uint32_t x) {
	return rotright(x, 17) ^ rotright(x, 19) ^ (x >> 10);
}


#define INITAL_STATE  {1779033703, 3144134277L, 1013904242, 2773480762L, 1359893119, 2600822924L, 528734635, 1541459225}

static void contextInit(struct context *ctx) {
	memcpy(&ctx->state, &((uint32_t [8])INITAL_STATE), sizeof(uint32_t [8]));
}


#define K  {1116352408, 1899447441, 3049323471L, 3921009573L, 961987163, 1508970993, 2453635748L, 2870763221L, 3624381080L, 310598401, 607225278, 1426881987, 1925078388, 2162078206L, 2614888103L, 3248222580L, 3835390401L, 4022224774L, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882L, 2821834349L, 2952996808L, 3210313671L, 3336571891L, 3584528711L, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350L, 2456956037L, 2730485921L, 2820302411L, 3259730800L, 3345764771L, 3516065817L, 3600352804L, 4094571909L, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452L, 2361852424L, 2428436474L, 2756734187L, 3204031479L, 3329325298L}

static void transform(struct context *ctx, uint8_t (*data)[]) {
	uint32_t m[64] = /*mark=CA2*/{0};

	uint32_t i = 0;
	uint32_t j = 0;

	while (i < 16) {
		const uint32_t x = ((uint32_t)(*data)[j + 0] << 24) | ((uint32_t)(*data)[j + 1] << 16) | ((uint32_t)(*data)[j + 2] << 8) | ((uint32_t)(*data)[j + 3] << 0);

		m[i] = x;
		j = j + 4;
		i = i + 1;
	}

	while (i < 64) {
		m[i] = (sig1(m[i - 2]) + m[i - 7] + sig0(m[i - 15]) + m[i - 16]);
		i = i + 1;
	}

	uint32_t x[8];
	memcpy(&x, &ctx->state, sizeof(uint32_t [8]));

	i = 0;
	while (i < 64) {
		const uint32_t t1 = x[7] + ep1(x[4]) + ch(x[4], x[5], x[6]) + ((uint32_t [64])K)[i] + m[i];
		const uint32_t t2 = ep0(x[0]) + maj(x[0], x[1], x[2]);

		x[7] = x[6];
		x[6] = x[5];
		x[5] = x[4];
		x[4] = (x[3] + t1);
		x[3] = x[2];
		x[2] = x[1];
		x[1] = x[0];
		x[0] = (t1 + t2);

		i = i + 1;
	}

	i = 0;
	while (i < 8) {
		ctx->state[i] = (ctx->state[i] + x[i]);
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

	ctx->data[i] = 128;

	i = i + 1;

	memset((void *)&ctx->data[i], 0, (size_t)(n - i));

	if (ctx->datalen >= 56) {
		transform(ctx, &ctx->data);
		memset((void *)&ctx->data, 0, 56);
	}
	ctx->bitlen = ctx->bitlen + (uint64_t)ctx->datalen * 8;

	ctx->data[63] = (uint8_t)(ctx->bitlen >> 0);
	ctx->data[62] = (uint8_t)(ctx->bitlen >> 8);
	ctx->data[61] = (uint8_t)(ctx->bitlen >> 16);
	ctx->data[60] = (uint8_t)(ctx->bitlen >> 24);
	ctx->data[59] = (uint8_t)(ctx->bitlen >> 32);
	ctx->data[58] = (uint8_t)(ctx->bitlen >> 40);
	ctx->data[57] = (uint8_t)(ctx->bitlen >> 48);
	ctx->data[56] = (uint8_t)(ctx->bitlen >> 56);

	transform(ctx, &ctx->data);

	i = 0;
	while (i < 4) {
		const uint32_t sh = 24 - i * 8;
		(*outHash)[i + 0] = (uint8_t)(ctx->state[0] >> sh);
		(*outHash)[i + 4] = (uint8_t)(ctx->state[1] >> sh);
		(*outHash)[i + 8] = (uint8_t)(ctx->state[2] >> sh);
		(*outHash)[i + 12] = (uint8_t)(ctx->state[3] >> sh);
		(*outHash)[i + 16] = (uint8_t)(ctx->state[4] >> sh);
		(*outHash)[i + 20] = (uint8_t)(ctx->state[5] >> sh);
		(*outHash)[i + 24] = (uint8_t)(ctx->state[6] >> sh);
		(*outHash)[i + 28] = (uint8_t)(ctx->state[7] >> sh);
		i = i + 1;
	}
}


void sha256_hash(uint8_t (*msg)[], uint32_t msgLen, sha256_Hash *outHash) {
	struct context ctx = /*mark=CR4*/(struct context){0};
	contextInit(&ctx);
	update(&ctx, msg, msgLen);
	final(&ctx, outHash);
}


