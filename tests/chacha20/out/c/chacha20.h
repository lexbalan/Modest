
#if !defined(CHACHA20_H)
#define CHACHA20_H
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
typedef uint32_t chacha20_Key[8];
typedef uint32_t chacha20_State[16];
typedef uint32_t chacha20_Block[16];
void chacha20_chacha20Block(uint32_t _state[16], uint32_t __out[16]);
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
void chacha20_makeState(uint32_t key[8], uint32_t counter, uint32_t nonce[3], uint32_t __out[16]);
#endif

