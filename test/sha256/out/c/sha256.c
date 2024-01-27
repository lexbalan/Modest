// ./out/c/sha256.c


#include <string.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdint.h>
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
uint32_t initMagic[8] = {
    1779033703U, 3144134277U, 1013904242, 2773480762U,
    1359893119U, 2600822924U, 528734635, 1541459225U
};;


void sha256_contextInit(SHA256_Context *ctx)
{
    //ctx.state := initMagic  // not worked; FIXIT!
    memcpy((void *)(uint32_t *)&ctx->state, (void *)(uint32_t *)&initMagic, 8 * 4);
}



//const k = [  // not worked; FIXIT!
uint32_t k[64] = {
    1116352408U, 1899447441U, 3049323471U, 3921009573U,
    961987163, 1508970993U, 2453635748U, 2870763221U,
    3624381080U, 310598401, 607225278, 1426881987U,
    1925078388U, 2162078206U, 2614888103U, 3248222580U,
    3835390401U, 4022224774U, 264347078, 604807628,
    770255983, 1249150122U, 1555081692U, 1996064986U,
    2554220882U, 2821834349U, 2952996808U, 3210313671U,
    3336571891U, 3584528711U, 113926993, 338241895,
    666307205, 773529912, 1294757372U, 1396182291U,
    1695183700U, 1986661051U, 2177026350U, 2456956037U,
    2730485921U, 2820302411U, 3259730800U, 3345764771U,
    3516065817U, 3600352804U, 4094571909U, 275423344,
    430227734, 506948616, 659060556, 883997877,
    958139571, 1322822218U, 1537002063U, 1747873779U,
    1955562222U, 2024104815U, 2227730452U, 2361852424U,
    2428436474U, 2756734187U, 3204031479U, 3329325298U
};;


void sha256_transform(SHA256_Context *ctx, uint8_t *data)
{
    uint32_t m[64];
    memcpy(&m, &(uint32_t [64]){0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, sizeof m);

    uint32_t i = 0;
    uint32_t j = 0;

    while (i < 16) {
        const uint32_t x = ((uint32_t)(uint8_t)data[j + 0]) << 24 | ((uint32_t)(uint8_t)data[j + 1]) << 16 | ((uint32_t)(uint8_t)data[j + 2]) << 8 | ((uint32_t)(uint8_t)data[j + 3]) << 0;

        m[i] = x;
        j = j + 4;
        i = i + 1;
    }

    while (i < 64) {
        m[i] = sig1(m[i - 2]) + m[i - 7] + sig0(m[i - 15]) + m[i - 16];
        i = i + 1;
    }

    uint32_t x[8];
    memcpy((void *)(uint32_t *)&x, (void *)(uint32_t *)&ctx->state, 8 * 4);

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
    uint32_t i = 0;
    while (i < len) {
        ctx->data[ctx->datalen] = data[i];
        ctx->datalen = ctx->datalen + 1;
        if (ctx->datalen == 64) {
            sha256_transform(ctx, (uint8_t *)(uint8_t *)&ctx->data);
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

    uint32_t n = 64;
    if (ctx->datalen < 56) {
        n = 56;
    }

    ctx->data[i] = 0x80;

    i = i + 1;

    memset((void *)&ctx->data[i], 0, ((size_t)(uint32_t)(n - i)));

    if (ctx->datalen >= 56) {
        sha256_transform(ctx, (uint8_t *)(uint8_t *)&ctx->data);
        memset((void *)(uint8_t *)&ctx->data, 0, 56);
    }

    // Append to the padding the total message's length in bits and transform.
    ctx->bitlen = ctx->bitlen + ((uint64_t)(uint32_t)ctx->datalen) * 8;

    ctx->data[63] = (uint8_t)(ctx->bitlen >> 0);
    ctx->data[62] = (uint8_t)(ctx->bitlen >> 8);
    ctx->data[61] = (uint8_t)(ctx->bitlen >> 16);
    ctx->data[60] = (uint8_t)(ctx->bitlen >> 24);
    ctx->data[59] = (uint8_t)(ctx->bitlen >> 32);
    ctx->data[58] = (uint8_t)(ctx->bitlen >> 40);
    ctx->data[57] = (uint8_t)(ctx->bitlen >> 48);
    ctx->data[56] = (uint8_t)(ctx->bitlen >> 56);

    sha256_transform(ctx, (uint8_t *)(uint8_t *)&ctx->data);

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
    sha256_contextInit(&ctx);
    sha256_update(&ctx, msg, len);
    sha256_final(&ctx, hash);
}

