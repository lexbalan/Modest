
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



typedef uint32_t Key[8];

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


static void chacha20Block(uint32_t (*_state)[16], uint32_t (*_sret_)[16]) {
	uint32_t state[16];
	memcpy(state, _state, sizeof(uint32_t [16]));

	uint32_t x[16];
	memcpy(&x, &state, sizeof(uint32_t [16]));// working copy

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
static void makeState(Key *key, uint32_t counter, uint32_t (*nonce)[3], uint32_t (*_sret_)[16]) {
	memcpy(_sret_, &(uint32_t [16]){
		0x61707865, 0x3320646E, 0x79622D32, 0x6B206574,
		(*key)[0], (*key)[1], (*key)[2], (*key)[3],
		(*key)[4], (*key)[5], (*key)[6], (*key)[7],
		counter, (*nonce)[0], (*nonce)[1], (*nonce)[2]
	}, sizeof(uint32_t [16]));
}


#define TEST_KEY  { \
	0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, \
	0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, \
	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, \
	0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F \
}

#define TEST_NONCE  { \
	0x0, 0x0, 0x0, 0x9, \
	0x0, 0x0, 0x0, 0x4A, \
	0x0 \
}

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

int main(void) {
	//printf("%s\n", *Str8 hello_world)

	char key[32] = TEST_KEY;
	uint32_t counter = 0x1;
	char nonce[12] = TEST_NONCE;
	uint32_t state[16];
	makeState((Key *)&key, counter, (uint32_t (*)[3])&nonce, &state);

	uint32_t block[16];
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


	return 0;
}


