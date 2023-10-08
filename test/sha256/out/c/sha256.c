
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>





typedef struct {
    uint8_t data[64];
    uint32_t datalen;
    uint64_t bitlen;
    uint32_t state[8];
} SHA256_Context;


uint32_t rotleft(uint32_t a, uint32_t b)
{
    return a << b | a >> (32 - b);
}

uint32_t rotright(uint32_t a, uint32_t b)
{
    return a >> b | a << (32 - b);
}

uint32_t ch(uint32_t x, uint32_t y, uint32_t z)
{
    return x & y ^ ~x & z;
}

uint32_t maj(uint32_t x, uint32_t y, uint32_t z)
{
    return x & y ^ x & z ^ y & z;
}

uint32_t ep0(uint32_t x)
{
    return rotright(x, 2) ^ rotright(x, 13) ^ rotright(x, 22);
}

uint32_t ep1(uint32_t x)
{
    return rotright(x, 6) ^ rotright(x, 11) ^ rotright(x, 25);
}

uint32_t sig0(uint32_t x)
{
    return rotright(x, 7) ^ rotright(x, 18) ^ x >> 3;
}

uint32_t sig1(uint32_t x)
{
    return rotright(x, 17) ^ rotright(x, 19) ^ x >> 10;
}



//const initMagic = [  // not worked & let; FIXIT
uint32_t initMagic[8] = (uint32_t [8]){0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A, 0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19
};


void sha256_contextInit(SHA256_Context *ctx)
{
    //ctx.state := initMagic  // not worked; FIXIT!
    memcpy((void *)&ctx->state[0], (void *)&initMagic[0], 8 * 4);
}



//const k = [  // not worked; FIXIT!
uint32_t k[64] = (uint32_t [64]){0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5, 0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5, 0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3, 0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174, 0xE49B69C1, 0xEFBE4786, 0x0FC19DC6, 0x240CA1CC, 0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA, 0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7, 0xC6E00BF3, 0xD5A79147, 0x06CA6351, 0x14292967, 0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13, 0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85, 0xA2BFE8A1, 0xA81A664B, 0xC24B8B70, 0xC76C51A3, 0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070, 0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5, 0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3, 0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208, 0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2
};


void sha256_transform(SHA256_Context *ctx, uint8_t *data)
{
    uint32_t m[64] = (uint32_t [64]){};

    uint32_t i = (uint32_t)0;
    uint32_t j = (uint32_t)0;

    while (i < 16) {
        const uint32_t x = (uint32_t)data[j + 0] << 24 | (uint32_t)data[j + 1] << 16 | (uint32_t)data[j + 2] << 8 | (uint32_t)data[j + 3] << 0;

        m[i] = x;
        j = j + 4;
        i = i + 1;
    }

    while (i < 64) {
        m[i] = sig1(m[i - 2]) + m[i - 7] + sig0(m[i - 15]) + m[i - 16];
        i = i + 1;
    }

    uint32_t x[8];
    memcpy((void *)&x[0], (void *)&ctx->state[0], 8 * 4);

    i = 0;
    while (i < 64) {
        const uint32_t t1 = x[7] + ep1(x[4]) + ch(x[4], x[5], x[6]) + k[i] + m[i];
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



void sha256_update(SHA256_Context *ctx, uint8_t *data, uint32_t len)
{
    uint32_t i = (uint32_t)0;
    while (i < len) {
        ctx->data[ctx->datalen] = data[i];
        ctx->datalen = ctx->datalen + 1;
        if (ctx->datalen == 64) {
            sha256_transform((SHA256_Context *)ctx, (uint8_t *)&ctx->data[0]);
            ctx->bitlen = ctx->bitlen + 512;
            ctx->datalen = 0;
        }
        i = i + 1;
    }
}


void sha256_final(SHA256_Context *ctx, uint8_t *hash)
{
    uint32_t i = ctx->datalen;

    // Pad whatever data is left in the buffer.

    uint32_t n = (uint32_t)64;
    if (ctx->datalen < 56) {
        n = 56;
    }

    ctx->data[i] = 0x80;

    i = i + 1;

    memset((void *)&ctx->data[i], 0, (size_t)(n - i));

    if (ctx->datalen >= 56) {
        sha256_transform((SHA256_Context *)ctx, (uint8_t *)&ctx->data[0]);
        memset((void *)&ctx->data[0], 0, 56);
    }

    // Append to the padding the total message's length in bits and transform.
    ctx->bitlen = ctx->bitlen + (uint64_t)ctx->datalen * 8;

    ctx->data[63] = (uint8_t)(ctx->bitlen >> 0);
    ctx->data[62] = (uint8_t)(ctx->bitlen >> 8);
    ctx->data[61] = (uint8_t)(ctx->bitlen >> 16);
    ctx->data[60] = (uint8_t)(ctx->bitlen >> 24);
    ctx->data[59] = (uint8_t)(ctx->bitlen >> 32);
    ctx->data[58] = (uint8_t)(ctx->bitlen >> 40);
    ctx->data[57] = (uint8_t)(ctx->bitlen >> 48);
    ctx->data[56] = (uint8_t)(ctx->bitlen >> 56);

    sha256_transform((SHA256_Context *)ctx, (uint8_t *)&ctx->data[0]);

    // Since this implementation uses little endian byte ordering
    // and SHA uses big endian, reverse all the bytes
    // when copying the final state to the output hash.

    i = 0;
    while (i < 4) {
        const uint32_t sh = 24 - i * 8;
        hash[i + 0] = (uint8_t)(ctx->state[0] >> sh);
        hash[i + 4] = (uint8_t)(ctx->state[1] >> sh);
        hash[i + 8] = (uint8_t)(ctx->state[2] >> sh);
        hash[i + 12] = (uint8_t)(ctx->state[3] >> sh);
        hash[i + 16] = (uint8_t)(ctx->state[4] >> sh);
        hash[i + 20] = (uint8_t)(ctx->state[5] >> sh);
        hash[i + 24] = (uint8_t)(ctx->state[6] >> sh);
        hash[i + 28] = (uint8_t)(ctx->state[7] >> sh);
        i = i + 1;
    }
}


// arg hash must be at least SHA256_BLOCK_SIZE
void sha256_doHash(uint8_t *msg, uint32_t len, uint8_t *hash)
{
    SHA256_Context ctx = (SHA256_Context){};
    sha256_contextInit((SHA256_Context *)&ctx);
    sha256_update((SHA256_Context *)&ctx, msg, len);
    sha256_final((SHA256_Context *)&ctx, hash);
}

