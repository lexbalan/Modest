
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



typedef uint32_t Key[8];
typedef uint32_t State[16];
typedef uint32_t Block[16];

static uint32_t rotl32(uint32_t x, uint32_t n) {
	return (x << n) | (x >> (32 - n));
}


static void quarterRound(uint32_t a, uint32_t b, uint32_t c, uint32_t d, uint32_t (*_sret_)[4]) {
	uint32_t a0 = a;
	uint32_t b0 = b;
	uint32_t c0 = c;
	uint32_t d0 = d;

	a0 = (a0 + b0);
	d0 = rotl32(d0 ^ a0, 16);

	c0 = (c0 + d0);
	b0 = rotl32(b0 ^ c0, 12);

	a0 = (a0 + b0);
	d0 = rotl32(d0 ^ a0, 8);

	c0 = (c0 + d0);
	b0 = rotl32(b0 ^ c0, 7);

	memcpy(_sret_, &(uint32_t [4]){a0, b0, c0, d0}, sizeof(uint32_t [4]));
}


static void chacha20Block(State *_state, Block *_sret_) {
	State state;
	memcpy(state, _state, sizeof(State));
	State x;
	memcpy(&x, &state, sizeof(State));// working copy

	int32_t i = 0;
	while (i < 10) {

		uint32_t r[4];

		// column rounds
		quarterRound(x[0], x[4], x[8], x[12], &r);
		x[0] = r[0];x[4] = r[1];x[8] = r[2];x[12] = r[3];

		quarterRound(x[1], x[5], x[9], x[13], &r);
		x[1] = r[0];x[5] = r[1];x[9] = r[2];x[13] = r[3];

		quarterRound(x[2], x[6], x[10], x[14], &r);
		x[2] = r[0];x[6] = r[1];x[10] = r[2];x[14] = r[3];

		quarterRound(x[3], x[7], x[11], x[15], &r);
		x[3] = r[0];x[7] = r[1];x[11] = r[2];x[15] = r[3];


		// diagonal rounds
		quarterRound(x[0], x[5], x[10], x[15], &r);
		x[0] = r[0];x[5] = r[1];x[10] = r[2];x[15] = r[3];

		quarterRound(x[1], x[6], x[11], x[12], &r);
		x[1] = r[0];x[6] = r[1];x[11] = r[2];x[12] = r[3];

		quarterRound(x[2], x[7], x[8], x[13], &r);
		x[2] = r[0];x[7] = r[1];x[8] = r[2];x[13] = r[3];

		quarterRound(x[3], x[4], x[9], x[14], &r);
		x[3] = r[0];x[4] = r[1];x[9] = r[2];x[14] = r[3];

		i = i + 1;
	}

	// add original state
	uint32_t out[16];
	int32_t j = 0;
	while (j < 16) {
		out[j] = (x[j] + state[j]);
		j = j + 1;
	}

	memcpy(_sret_, &out, sizeof(uint32_t [16]));
}


// nonce = number used once
// Чтобы один и тот же ключ можно было использовать много раз.
// Если шифровать два сообщения одним ключом keystream будет одинаковым - это катастрофа
// Он НЕ секретный. Его обычно: передают вместе с сообщением
// кладут в заголовок пакета хранят рядом с ciphertext
// ⚠️ Самое важное правило: Nonce нельзя повторять с тем же ключом. Никогда.
// Важное правило: Nonce не нужно секретить. Ты можешь просто записать его в самое начало зашифрованного файла (первые 12 байт).
// Чтобы расшифровать файл, тебе понадобятся твой секретный ключ (который в голове или в сейфе) и этот Nonce
// (который прикреплен к файлу).
// Итог: Оставь Nonce открытым. Сила ChaCha20 не в секретности Nonce, а в том, что даже зная его, никто не сможет вычислить ключ.

// counter он говорит алгоритму - какой блок keystream генерировать
static void makeState(Key *key, uint32_t counter, uint32_t (*nonce)[3], State *_sret_) {
	memcpy(_sret_, &(State){
		0x61707865, 0x3320646E, 0x79622D32, 0x6B206574,
		(*key)[0], (*key)[1], (*key)[2], (*key)[3],
		(*key)[4], (*key)[5], (*key)[6], (*key)[7],
		counter, (*nonce)[0], (*nonce)[1], (*nonce)[2]
	}, sizeof(State));
}



struct context {
	char (*key)[32];
	uint32_t nonce[3];
	uint32_t blockCounter;
	Block block;
	uint32_t blockOffset;
};

static struct context init(char (*key)[32], uint32_t (*_nonce)[3]) {
	uint32_t nonce[3];
	memcpy(nonce, _nonce, sizeof(uint32_t [3]));
	return (struct context){
		.key = key,
		.nonce = {nonce[0], nonce[1], nonce[2]},
		.blockCounter = 0,
		.blockOffset = (uint32_t)sizeof(Block)
	};
}


static void cipher(struct context *ctx, char (*data)[], uint32_t len) {
	uint32_t i = 0;
	char (*bptr)[] = NULL;
	while (i < len) {
		// Нужно сгенерировать новый блок?
		if (ctx->blockOffset == (uint32_t)sizeof(Block)) {
			//printf("UH!\n")
			State state;
			makeState((Key *)ctx->key, ctx->blockCounter, &ctx->nonce, &state);
			memcpy((uint32_t (*)[16 - 13])&state[13], (uint32_t (*)[3 - 0])&ctx->nonce[0], sizeof(uint32_t [16 - 13]));
			//state[13] = ctx.nonce[0]
			//state[14] = ctx.nonce[1]
			//state[15] = ctx.nonce[2]

			chacha20Block(&state, &ctx->block);
			ctx->blockOffset = 0;
			bptr = (char (*)[])&ctx->block;
		}

		(*data)[i] = (*data)[i] ^ (*bptr)[ctx->blockOffset];

		ctx->blockOffset = ctx->blockOffset + 1;
		i = i + 1;
	}
}


static char testKey[32] = {
	0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7,
	0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF,
	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
	0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F
};

static char testNonce[12] = {
	0x0, 0x0, 0x0, 0x9,
	0x0, 0x0, 0x0, 0x4A,
	0x0
};

static uint32_t testNonce2[3] = {
	0x9,
	0x4A,
	0x0
};

#define TEST_RESULT  { \
	0x10, 0xF1, 0xE7, 0xE4, 0xD1, 0x3B, 0x59, 0x15, \
	0x50, 0xF, 0xDD, 0x1F, 0xA3, 0x20, 0x71, 0xC4, \
	0xC7, 0xD1, 0xF4, 0xC7, 0x33, 0xC0, 0x68, 0x3, \
	0x4, 0x22, 0xAA, 0x9A, 0xC3, 0xD4, 0x6C, 0x4E, \
	0xD2, 0x82, 0x64, 0x46, 0x7, 0x9F, 0xAA, 0x9, \
	0x14, 0xC2, 0xD7, 0x5, 0xD9, 0x8B, 0x2, 0xA2, \
	0xB5, 0x12, 0x9C, 0xD1, 0xDE, 0x16, 0x4E, 0xB9, \
	0xCB, 0xD0, 0x83, 0xE8, 0xA2, 0x50, 0x3C, 0x4E \
}

#define LOREM1024  {'L', 'o', 'r', 'e', 'm', ' ', 'i', 'p', 's', 'u', 'm', ' ', 'd', 'o', 'l', 'o', 'r', ' ', 's', 'i', 't', ' ', 'a', 'm', 'e', 't', ',', ' ', 'c', 'o', 'n', 's', 'e', 'c', 't', 'e', 't', 'u', 'e', 'r', ' ', 'a', 'd', 'i', 'p', 'i', 's', 'c', 'i', 'n', 'g', ' ', 'e', 'l', 'i', 't', '.', ' ', 'A', 'e', 'n', 'e', 'a', 'n', ' ', 'c', 'o', 'm', 'm', 'o', 'd', 'o', ' ', 'l', 'i', 'g', 'u', 'l', 'a', ' ', 'e', 'g', 'e', 't', ' ', 'd', 'o', 'l', 'o', 'r', '.', ' ', 'A', 'e', 'n', 'e', 'a', 'n', ' ', 'm', 'a', 's', 's', 'a', '.', ' ', 'C', 'u', 'm', ' ', 's', 'o', 'c', 'i', 'i', 's', ' ', 'n', 'a', 't', 'o', 'q', 'u', 'e', ' ', 'p', 'e', 'n', 'a', 't', 'i', 'b', 'u', 's', ' ', 'e', 't', ' ', 'm', 'a', 'g', 'n', 'i', 's', ' ', 'd', 'i', 's', ' ', 'p', 'a', 'r', 't', 'u', 'r', 'i', 'e', 'n', 't', ' ', 'm', 'o', 'n', 't', 'e', 's', ',', ' ', 'n', 'a', 's', 'c', 'e', 't', 'u', 'r', ' ', 'r', 'i', 'd', 'i', 'c', 'u', 'l', 'u', 's', ' ', 'm', 'u', 's', '.', ' ', 'D', 'o', 'n', 'e', 'c', ' ', 'q', 'u', 'a', 'm', ' ', 'f', 'e', 'l', 'i', 's', ',', ' ', 'u', 'l', 't', 'r', 'i', 'c', 'i', 'e', 's', ' ', 'n', 'e', 'c', ',', ' ', 'p', 'e', 'l', 'l', 'e', 'n', 't', 'e', 's', 'q', 'u', 'e', ' ', 'e', 'u', ',', ' ', 'p', 'r', 'e', 't', 'i', 'u', 'm', ' ', 'q', 'u', 'i', 's', ',', ' ', 's', 'e', 'm', '.', ' ', 'N', 'u', 'l', 'l', 'a', ' ', 'c', 'o', 'n', 's', 'e', 'q', 'u', 'a', 't', ' ', 'm', 'a', 's', 's', 'a', ' ', 'q', 'u', 'i', 's', ' ', 'e', 'n', 'i', 'm', '.', ' ', 'D', 'o', 'n', 'e', 'c', ' ', 'p', 'e', 'd', 'e', ' ', 'j', 'u', 's', 't', 'o', ',', ' ', 'f', 'r', 'i', 'n', 'g', 'i', 'l', 'l', 'a', ' ', 'v', 'e', 'l', ',', ' ', 'a', 'l', 'i', 'q', 'u', 'e', 't', ' ', 'n', 'e', 'c', ',', ' ', 'v', 'u', 'l', 'p', 'u', 't', 'a', 't', 'e', ' ', 'e', 'g', 'e', 't', ',', ' ', 'a', 'r', 'c', 'u', '.', ' ', 'I', 'n', ' ', 'e', 'n', 'i', 'm', ' ', 'j', 'u', 's', 't', 'o', ',', ' ', 'r', 'h', 'o', 'n', 'c', 'u', 's', ' ', 'u', 't', ',', ' ', 'i', 'm', 'p', 'e', 'r', 'd', 'i', 'e', 't', ' ', 'a', ',', ' ', 'v', 'e', 'n', 'e', 'n', 'a', 't', 'i', 's', ' ', 'v', 'i', 't', 'a', 'e', ',', ' ', 'j', 'u', 's', 't', 'o', '.', ' ', 'N', 'u', 'l', 'l', 'a', 'm', ' ', 'd', 'i', 'c', 't', 'u', 'm', ' ', 'f', 'e', 'l', 'i', 's', ' ', 'e', 'u', ' ', 'p', 'e', 'd', 'e', ' ', 'm', 'o', 'l', 'l', 'i', 's', ' ', 'p', 'r', 'e', 't', 'i', 'u', 'm', '.', ' ', 'I', 'n', 't', 'e', 'g', 'e', 'r', ' ', 't', 'i', 'n', 'c', 'i', 'd', 'u', 'n', 't', '.', ' ', 'C', 'r', 'a', 's', ' ', 'd', 'a', 'p', 'i', 'b', 'u', 's', '.', ' ', 'V', 'i', 'v', 'a', 'm', 'u', 's', ' ', 'e', 'l', 'e', 'm', 'e', 'n', 't', 'u', 'm', ' ', 's', 'e', 'm', 'p', 'e', 'r', ' ', 'n', 'i', 's', 'i', '.', ' ', 'A', 'e', 'n', 'e', 'a', 'n', ' ', 'v', 'u', 'l', 'p', 'u', 't', 'a', 't', 'e', ' ', 'e', 'l', 'e', 'i', 'f', 'e', 'n', 'd', ' ', 't', 'e', 'l', 'l', 'u', 's', '.', ' ', 'A', 'e', 'n', 'e', 'a', 'n', ' ', 'l', 'e', 'o', ' ', 'l', 'i', 'g', 'u', 'l', 'a', ',', ' ', 'p', 'o', 'r', 't', 't', 'i', 't', 'o', 'r', ' ', 'e', 'u', ',', ' ', 'c', 'o', 'n', 's', 'e', 'q', 'u', 'a', 't', ' ', 'v', 'i', 't', 'a', 'e', ',', ' ', 'e', 'l', 'e', 'i', 'f', 'e', 'n', 'd', ' ', 'a', 'c', ',', ' ', 'e', 'n', 'i', 'm', '.', ' ', 'A', 'l', 'i', 'q', 'u', 'a', 'm', ' ', 'l', 'o', 'r', 'e', 'm', ' ', 'a', 'n', 't', 'e', ',', ' ', 'd', 'a', 'p', 'i', 'b', 'u', 's', ' ', 'i', 'n', ',', ' ', 'v', 'i', 'v', 'e', 'r', 'r', 'a', ' ', 'q', 'u', 'i', 's', ',', ' ', 'f', 'e', 'u', 'g', 'i', 'a', 't', ' ', 'a', ',', ' ', 't', 'e', 'l', 'l', 'u', 's', '.', ' ', 'P', 'h', 'a', 's', 'e', 'l', 'l', 'u', 's', ' ', 'v', 'i', 'v', 'e', 'r', 'r', 'a', ' ', 'n', 'u', 'l', 'l', 'a', ' ', 'u', 't', ' ', 'm', 'e', 't', 'u', 's', ' ', 'v', 'a', 'r', 'i', 'u', 's', ' ', 'l', 'a', 'o', 'r', 'e', 'e', 't', '.', ' ', 'Q', 'u', 'i', 's', 'q', 'u', 'e', ' ', 'r', 'u', 't', 'r', 'u', 'm', '.', ' ', 'A', 'e', 'n', 'e', 'a', 'n', ' ', 'i', 'm', 'p', 'e', 'r', 'd', 'i', 'e', 't', '.', ' ', 'E', 't', 'i', 'a', 'm', ' ', 'u', 'l', 't', 'r', 'i', 'c', 'i', 'e', 's', ' ', 'n', 'i', 's', 'i', ' ', 'v', 'e', 'l', ' ', 'a', 'u', 'g', 'u', 'e', '.', ' ', 'C', 'u', 'r', 'a', 'b', 'i', 't', 'u', 'r', ' ', 'u', 'l', 'l', 'a', 'm', 'c', 'o', 'r', 'p', 'e', 'r', ' ', 'u', 'l', 't', 'r', 'i', 'c', 'i', 'e', 's', ' ', 'n', 'i', 's', 'i', '.', ' ', 'N', 'a', 'm', ' ', 'e', 'g', 'e', 't', ' ', 'd', 'u', 'i', '.', ' ', 'E', 't', 'i', 'a', 'm', ' ', 'r', 'h', 'o', 'n', 'c', 'u', 's', '.', ' ', 'M', 'a', 'e', 'c', 'e', 'n', 'a', 's', ' ', 't', 'e', 'm', 'p', 'u', 's', ',', ' ', 't', 'e', 'l', 'l', 'u', 's', ' ', 'e', 'g', 'e', 't', ' ', 'c', 'o', 'n', 'd', 'i', 'm', 'e', 'n', 't', 'u', 'm', ' ', 'r', 'h', 'o', 'n', 'c', 'u', 's', ',', ' ', 's', 'e', 'm', ' ', 'q', 'u', 'a', 'm', ' ', 's', 'e', 'm', 'p', 'e', 'r', ' ', 'l', 'i', 'b', 'e', 'r', 'o', ',', ' ', 's', 'i', 't', ' ', 'a', 'm', 'e', 't', ' ', 'a', 'd', 'i', 'p', 'i', 's', 'c', 'i', 'n', 'g', ' ', 's', 'e', 'm', ' ', 'n', 'e', 'q', 'u', 'e', ' ', 's', 'e', 'd', ' ', 'i', 'p', 's', 'u', 'm', '.', ' ', 'N', 'a', 'm', ' ', 'q', 'u', 'a', 'm', ' ', 'n', 'u', 'n', 'c', ',', ' ', 'b', 'l', 'a', 'n', 'd', 'i', 't', ' ', 'v', 'e'}

static char xlorem1024[1024] = LOREM1024;


static void test0(void);

int main(void) {
	//printf("%s\n", *Str8 hello_world)
	//var data = []Byte [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	struct context ctx = init(&testKey, &testNonce2);
	char (*const dptr)[] = (char (*)[])xlorem1024;
	cipher(&ctx, dptr, 1024);

	int32_t i = 0;
	while (i < 10) {
		printf("%c", xlorem1024[i]);
		printf("%x\n", (uint32_t)(uint8_t)xlorem1024[i]);
		i = i + 1;
	}

	struct context ctx2 = init(&testKey, &testNonce2);
	cipher(&ctx2, dptr, 1024);

	i = 0;
	while (i < 1024) {
		printf("%c", xlorem1024[i]);
		i = i + 1;
	}

	test0();

	return 0;
}


static void test0(void) {
	char key[32];
	memcpy(&key, &testKey, sizeof(char [32]));
	uint32_t counter = 0x1;
	char nonce[12];
	memcpy(&nonce, &testNonce, sizeof(char [12]));
	State state;
	makeState((Key *)&key, counter, (uint32_t (*)[3])&nonce, &state);

	Block block;
	chacha20Block(&state, &block);

	int32_t i = 0;
	while (i < 16) {
		printf("%08x\n", block[i]);
		i = i + 1;
	}

	char (*const bptr)[64] = (char (*)[64])&block;

	if (memcmp(bptr, &((char [64])TEST_RESULT), sizeof(char [64])) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}
}


