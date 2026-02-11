// tests/chacha20/src/main.m

include "libc/ctypes64"
include "libc/stdio"


pragma unsafe


type Key = [8]Word32


func rotl32 (x: Word32, n: Nat32) -> Word32 {
	return (x << n) or (x >> (32 - n))
}


func quarterRound (a: Word32, b: Word32, c: Word32, d: Word32) -> [4]Word32 {
	var a0 = a
	var b0 = b
	var c0 = c
	var d0 = d

	a0 = Word32 (Nat32 a0 + Nat32 b0)
	d0 = rotl32(d0 xor a0, 16)

	c0 = Word32 (Nat32 c0 + Nat32 d0)
	b0 = rotl32(b0 xor c0, 12)

	a0 = Word32 (Nat32 a0 + Nat32 b0)
	d0 = rotl32(d0 xor a0, 8)

	c0 = Word32 (Nat32 c0 + Nat32 d0)
	b0 = rotl32(b0 xor c0, 7)

	return [a0, b0, c0, d0]
}


func chacha20Block (state: [16]Word32) -> [16]Word32 {

	var x = state  // working copy

	var i: Int32 = 0
	while i < 10 {

		var r: [4]Word32

		// column rounds
		r = quarterRound(x[0], x[4], x[8],  x[12])
		x[0] = r[0]; x[4] = r[1]; x[8] = r[2]; x[12] = r[3];

		r = quarterRound(x[1], x[5], x[9],  x[13])
		x[1] = r[0]; x[5] = r[1]; x[9] = r[2]; x[13] = r[3];

		r = quarterRound(x[2], x[6], x[10], x[14])
		x[2] = r[0]; x[6] = r[1]; x[10] = r[2]; x[14] = r[3];

		r = quarterRound(x[3], x[7], x[11], x[15])
		x[3] = r[0]; x[7] = r[1]; x[11] = r[2]; x[15] = r[3];


		// diagonal rounds
		r = quarterRound(x[0], x[5], x[10], x[15])
		x[0] = r[0]; x[5] = r[1]; x[10] = r[2]; x[15] = r[3];

		r = quarterRound(x[1], x[6], x[11], x[12])
		x[1] = r[0]; x[6] = r[1]; x[11] = r[2]; x[12] = r[3];

		r = quarterRound(x[2], x[7], x[8],  x[13])
		x[2] = r[0]; x[7] = r[1]; x[8] = r[2];  x[13] = r[3];

		r = quarterRound(x[3], x[4], x[9],  x[14])
		x[3] = r[0]; x[4] = r[1]; x[9] = r[2];  x[14] = r[3];

		i = i + 1
	}

	// add original state
	var out: [16]Word32
	var j: Int32 = 0
	while j < 16 {
		out[j] = Word32 (Nat32 x[j] + Nat32 state[j])
		j = j + 1
	}

	return out
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
func makeState (key: *Key, counter: Word32, nonce: *[3]Word32) -> [16]Word32 {
	return [
		0x61707865, 0x3320646e, 0x79622d32, 0x6b206574,
		key[0], key[1], key[2], key[3],
		key[4], key[5], key[6], key[7],
		counter, nonce[0], nonce[1], nonce[2]
	]
}



const testKey = [
	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
]

const testNonce = [
	0x00, 0x00, 0x00, 0x09,
	0x00, 0x00, 0x00, 0x4a,
	0x00, 0x00, 0x00, 0x00,
]

const testResult = [
	0x10, 0xf1, 0xe7, 0xe4, 0xd1, 0x3b, 0x59, 0x15,
	0x50, 0x0f, 0xdd, 0x1f, 0xa3, 0x20, 0x71, 0xc4,
	0xc7, 0xd1, 0xf4, 0xc7, 0x33, 0xc0, 0x68, 0x03,
	0x04, 0x22, 0xaa, 0x9a, 0xc3, 0xd4, 0x6c, 0x4e,
	0xd2, 0x82, 0x64, 0x46, 0x07, 0x9f, 0xaa, 0x09,
	0x14, 0xc2, 0xd7, 0x05, 0xd9, 0x8b, 0x02, 0xa2,
	0xb5, 0x12, 0x9c, 0xd1, 0xde, 0x16, 0x4e, 0xb9,
	0xcb, 0xd0, 0x83, 0xe8, 0xa2, 0x50, 0x3c, 0x4e,
]



public func main () -> Int {
	//printf("%s\n", *Str8 hello_world)

	var key: [32]Byte = testKey
	var counter: Word32 = 1
	var nonce: [12]Byte = testNonce
	var state = makeState(unsafe *Key &key, counter, unsafe *[3]Word32 &nonce)

	var block = chacha20Block(state)

	var i = 0
	while i < 16 {
		printf("%08x\n", block[i])
		++i
	}

	let bptr = unsafe *[64]Byte &block

	if *bptr == testResult {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}


	return 0
}

