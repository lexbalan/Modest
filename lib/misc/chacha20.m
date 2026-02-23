// chacha20.m

public type Key = [8]Word32
public type State = [16]Word32
public type Block = [16]Word32


@inlinehint
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


public func chacha20Block (state: State) -> Block {
	var x = state  // working copy

	var i: Int32 = 0
	while i < 10 {

		var r: [4]Word32

		// column rounds
		r = quarterRound(x[0], x[4], x[8],  x[12])
		x[00] = r[00]
		x[04] = r[01]
		x[08] = r[02]
		x[12] = r[03]

		r = quarterRound(x[1], x[5], x[9],  x[13])
		x[01] = r[00]
		x[05] = r[01]
		x[09] = r[02]
		x[13] = r[03]

		r = quarterRound(x[2], x[6], x[10], x[14])
		x[02] = r[00]
		x[06] = r[01]
		x[10] = r[02]
		x[14] = r[03]

		r = quarterRound(x[3], x[7], x[11], x[15])
		x[03] = r[00]
		x[07] = r[01]
		x[11] = r[02]
		x[15] = r[03]


		// diagonal rounds
		r = quarterRound(x[0], x[5], x[10], x[15])
		x[00] = r[00]
		x[05] = r[01]
		x[10] = r[02]
		x[15] = r[03]

		r = quarterRound(x[1], x[6], x[11], x[12])
		x[01] = r[00]
		x[06] = r[01]
		x[11] = r[02]
		x[12] = r[03]

		r = quarterRound(x[2], x[7], x[8],  x[13])
		x[02] = r[00]
		x[07] = r[01]
		x[08] = r[02]
		x[13] = r[03]

		r = quarterRound(x[3], x[4], x[9],  x[14])
		x[03] = r[00]
		x[04] = r[01]
		x[09] = r[02]
		x[14] = r[03]

		++i
	}

	// add original state
	var out: [16]Word32
	var j: Int32 = 0
	while j < 16 {
		out[j] = Word32 (Nat32 x[j] + Nat32 state[j])
		++j
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
public func makeState (key: *Key, counter: Word32, nonce: *[3]Word32) -> State {
	return [
		0x61707865, 0x3320646e, 0x79622d32, 0x6b206574,
		key[0],     key[1],     key[2],     key[3],
		key[4],     key[5],     key[6],     key[7],
		counter,    nonce[0],   nonce[1],   nonce[2]
	]
}


