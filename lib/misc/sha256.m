// sha256.m

pragma do_not_include

include "libc/ctypes64"
include "libc/string"


public const hashSize = 32

public type Hash = [hashSize]Word8


type Context = record {
	data: [64]Word8
	datalen: Nat32
	bitlen: Nat64
	state: [8]Word32
}


@inline
func rotleft(a: Word32, b: Nat32) -> Word32 {
	return (a << b) or (a >> (32 - b))
}

@inline
func rotright(a: Word32, b: Nat32) -> Word32 {
	return (a >> b) or (a << (32 - b))
}

@inline
func ch(x: Word32, y: Word32, z: Word32) -> Word32 {
	return (x and y) xor (not x and z)
}

@inline
func maj(x: Word32, y: Word32, z: Word32) -> Word32 {
	return (x and y) xor (x and z) xor (y and z)
}

@inline
func ep0(x: Word32) -> Word32 {
	return rotright(x, 2) xor rotright(x, 13) xor rotright(x, 22)
}

@inline
func ep1(x: Word32) -> Word32 {
	return rotright(x, 6) xor rotright(x, 11) xor rotright(x, 25)
}

@inline
func sig0(x: Word32) -> Word32 {
	return rotright(x, 7) xor rotright(x, 18) xor (x >> 3)
}

@inline
func sig1(x: Word32) -> Word32 {
	return rotright(x, 17) xor rotright(x, 19) xor (x >> 10)
}



const initalState = [
	0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
	0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
]


func contextInit (ctx: *Context) -> Unit {
	ctx.state = initalState
}


const k = [
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
	0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
	0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
	0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
	0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
	0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
	0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
	0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
	0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
]


func transform (ctx: *Context, data: *[]Word8) -> Unit {
	var m = [64]Word32 []

	var i = Nat32 0
	var j = Nat32 0

	while i < 16 {
		let x = (Word32 data[j + 0] << 24) or (Word32 data[j + 1] << 16) or (Word32 data[j + 2] << 08) or (Word32 data[j + 3] << 00)

		m[i] = x
		j = j + 4
		++i
	}

	while i < 64 {
		m[i] = Word32 (Nat32 sig1(m[i - 2]) + Nat32 m[i - 7] + Nat32 sig0(m[i - 15]) + Nat32 m[i - 16])
		++i
	}

	var x: [8]Word32 = ctx.state

	i = 0
	while i < 64 {
		let t1 = Nat32 x[7] + Nat32 ep1(x[4]) + Nat32 ch(x[4], x[5], x[6]) + Nat32 k[i] + Nat32 m[i]
		let t2 = Nat32 ep0(x[0]) + Nat32 maj(x[0], x[1], x[2])

		x[7] = x[6]
		x[6] = x[5]
		x[5] = x[4]
		x[4] = Word32 (Nat32 x[3] + t1)
		x[3] = x[2]
		x[2] = x[1]
		x[1] = x[0]
		x[0] = Word32 (t1 + t2)

		++i
	}

	i = 0
	while i < 8 {
		ctx.state[i] = Word32 (Nat32 ctx.state[i] + Nat32 x[i])
		++i
	}
}


func update (ctx: *Context, msg: *[]Word8, msgLen: Nat32) -> Unit {
	var i = Nat32 0
	while i < msgLen {
		ctx.data[ctx.datalen] = msg[i]
		ctx.datalen = ctx.datalen + 1
		if ctx.datalen == 64 {
			transform(ctx, &ctx.data)
			ctx.bitlen = ctx.bitlen + 512
			ctx.datalen = 0
		}
		++i
	}
}


func final (ctx: *Context, outHash: *Hash) -> Unit {
	var i: Nat32 = ctx.datalen

	// Pad whatever data is left in the buffer.

	var n = Nat32 64
	if ctx.datalen < 56 {
		n = 56
	}

	ctx.data[i] = 0x80

	++i

	memset(&ctx.data[i], 0, SizeT (n - i))
	//ctx.data[i:n-i] = []

	if ctx.datalen >= 56 {
		transform(ctx, &ctx.data)
		memset(&ctx.data, 0, 56)
		//ctx.data[0:56] = []
	}

	// Append to the padding the total message's length in bits and transform.
	ctx.bitlen = ctx.bitlen + Nat64 ctx.datalen * 8

	ctx.data[63] = unsafe Word8 (Word64 ctx.bitlen >> 00)
	ctx.data[62] = unsafe Word8 (Word64 ctx.bitlen >> 08)
	ctx.data[61] = unsafe Word8 (Word64 ctx.bitlen >> 16)
	ctx.data[60] = unsafe Word8 (Word64 ctx.bitlen >> 24)
	ctx.data[59] = unsafe Word8 (Word64 ctx.bitlen >> 32)
	ctx.data[58] = unsafe Word8 (Word64 ctx.bitlen >> 40)
	ctx.data[57] = unsafe Word8 (Word64 ctx.bitlen >> 48)
	ctx.data[56] = unsafe Word8 (Word64 ctx.bitlen >> 56)

	transform(ctx, &ctx.data)

	// Since this implementation uses little endian byte ordering
	// and SHA uses big endian, reverse all the bytes
	// when copying the final state to the output hash.

	i = 0
	while i < 4 {
		let sh = 24 - i * 8
		outHash[i + 00] = unsafe Word8 (ctx.state[0] >> sh)
		outHash[i + 04] = unsafe Word8 (ctx.state[1] >> sh)
		outHash[i + 08] = unsafe Word8 (ctx.state[2] >> sh)
		outHash[i + 12] = unsafe Word8 (ctx.state[3] >> sh)
		outHash[i + 16] = unsafe Word8 (ctx.state[4] >> sh)
		outHash[i + 20] = unsafe Word8 (ctx.state[5] >> sh)
		outHash[i + 24] = unsafe Word8 (ctx.state[6] >> sh)
		outHash[i + 28] = unsafe Word8 (ctx.state[7] >> sh)
		++i
	}
}


public func hash (msg: *[]Word8, msgLen: Nat32, outHash: *Hash) -> Unit {
	var ctx = Context {}
	contextInit(&ctx)
	update(&ctx, msg, msgLen)
	final(&ctx, outHash)
}


