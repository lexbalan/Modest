include "ctypes64"
include "stdio"


type Key = [8]Word32


func rotl32 (x: Word32, n: Nat32) -> Word32 {
	return (x << n) or (x >> (32 - n))
}


func quarterRound (a: Word32, b: Word32, c: Word32, d: Word32) -> [4]Word32 {
	var a0: Word32 = a
	var b0: Word32 = b
	var c0: Word32 = c
	var d0: Word32 = d

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

	var x: [16]Word32 = state; // working copy

	var i: Int32 = 0
	while i < 10 {

		var r: [4]Word32

		// column rounds
		r = quarterRound(x[0], x[4], x[8], x[12])
		x[0] = r[0]; x[4] = r[1]; x[8] = r[2]; x[12] = r[3]

		r = quarterRound(x[1], x[5], x[9], x[13])
		x[1] = r[0]; x[5] = r[1]; x[9] = r[2]; x[13] = r[3]

		r = quarterRound(x[2], x[6], x[10], x[14])
		x[2] = r[0]; x[6] = r[1]; x[10] = r[2]; x[14] = r[3]

		r = quarterRound(x[3], x[7], x[11], x[15])
		x[3] = r[0]; x[7] = r[1]; x[11] = r[2]; x[15] = r[3]


		// diagonal rounds
		r = quarterRound(x[0], x[5], x[10], x[15])
		x[0] = r[0]; x[5] = r[1]; x[10] = r[2]; x[15] = r[3]

		r = quarterRound(x[1], x[6], x[11], x[12])
		x[1] = r[0]; x[6] = r[1]; x[11] = r[2]; x[12] = r[3]

		r = quarterRound(x[2], x[7], x[8], x[13])
		x[2] = r[0]; x[7] = r[1]; x[8] = r[2]; x[13] = r[3]

		r = quarterRound(x[3], x[4], x[9], x[14])
		x[3] = r[0]; x[4] = r[1]; x[9] = r[2]; x[14] = r[3]

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
		0x61707865, 0x3320646E, 0x79622D32, 0x6B206574
		key[0], key[1], key[2], key[3]
		key[4], key[5], key[6], key[7]
		counter, nonce[0], nonce[1], nonce[2]
	]
}



const testKey = [
	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
	0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17
	0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F
]

const testNonce = [
	0x00, 0x00, 0x00, 0x09
	0x00, 0x00, 0x00, 0x4A
]

const testResult = [
	0x10, 0xF1, 0xE7, 0xE4, 0xD1, 0x3B, 0x59, 0x15
	0x50, 0x0F, 0xDD, 0x1F, 0xA3, 0x20, 0x71, 0xC4
	0xC7, 0xD1, 0xF4, 0xC7, 0x33, 0xC0, 0x68, 0x03
	0x04, 0x22, 0xAA, 0x9A, 0xC3, 0xD4, 0x6C, 0x4E
	0xD2, 0x82, 0x64, 0x46, 0x07, 0x9F, 0xAA, 0x09
	0x14, 0xC2, 0xD7, 0x05, 0xD9, 0x8B, 0x02, 0xA2
	0xB5, 0x12, 0x9C, 0xD1, 0xDE, 0x16, 0x4E, 0xB9
	0xCB, 0xD0, 0x83, 0xE8, 0xA2, 0x50, 0x3C, 0x4E
]



public func main () -> Int {
	//printf("%s\n", *Str8 hello_world)

	var key: [32]Byte = testKey
	var counter: Word32 = 1
	var nonce: [12]Byte = testNonce
	var state: [16]Word32 = makeState(unsafe *Key &key, counter, unsafe *[3]Word32 &nonce)

	var block: [16]Word32 = chacha20Block(state)

	var i: Int32 = 0
	while i < 16 {
		printf("%08x\n", block[i])
		i = i + 1
	}

	let bptr: *[64]Byte = unsafe *[64]Byte &block

	if *bptr == testResult {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}


	return 0
}

