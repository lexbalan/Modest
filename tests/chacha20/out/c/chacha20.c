
#include "chacha20.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>



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


void chacha20_chacha20Block(chacha20_State *_state, chacha20_Block *_sret_) {
	chacha20_State state;
	memcpy(state, _state, sizeof(chacha20_State));
	chacha20_State x;
	memcpy(&x, &state, sizeof(chacha20_State));

	int32_t i = 0;
	while (i < 10) {

		uint32_t r[4];
		quarterRound(x[0], x[4], x[8], x[12], &r);
		x[0] = r[0];
		x[4] = r[1];
		x[8] = r[2];
		x[12] = r[3];

		quarterRound(x[1], x[5], x[9], x[13], &r);
		x[1] = r[0];
		x[5] = r[1];
		x[9] = r[2];
		x[13] = r[3];

		quarterRound(x[2], x[6], x[10], x[14], &r);
		x[2] = r[0];
		x[6] = r[1];
		x[10] = r[2];
		x[14] = r[3];

		quarterRound(x[3], x[7], x[11], x[15], &r);
		x[3] = r[0];
		x[7] = r[1];
		x[11] = r[2];
		x[15] = r[3];
		quarterRound(x[0], x[5], x[10], x[15], &r);
		x[0] = r[0];
		x[5] = r[1];
		x[10] = r[2];
		x[15] = r[3];

		quarterRound(x[1], x[6], x[11], x[12], &r);
		x[1] = r[0];
		x[6] = r[1];
		x[11] = r[2];
		x[12] = r[3];

		quarterRound(x[2], x[7], x[8], x[13], &r);
		x[2] = r[0];
		x[7] = r[1];
		x[8] = r[2];
		x[13] = r[3];

		quarterRound(x[3], x[4], x[9], x[14], &r);
		x[3] = r[0];
		x[4] = r[1];
		x[9] = r[2];
		x[14] = r[3];

		i = i + 1;
	}
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
void chacha20_makeState(chacha20_Key *key, uint32_t counter, uint32_t (*nonce)[3], chacha20_State *_sret_) {
	memcpy(_sret_, &(chacha20_State){
		0x61707865, 0x3320646E, 0x79622D32, 0x6B206574,
		(*key)[0], (*key)[1], (*key)[2], (*key)[3],
		(*key)[4], (*key)[5], (*key)[6], (*key)[7],
		counter, (*nonce)[0], (*nonce)[1], (*nonce)[2]
	}, sizeof(chacha20_State));
}


