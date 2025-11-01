include "ctypes64"
include "string"
// sha256.m


public const hashSize = 32

public type Hash = [hashSize]Word8


type Context = record {
	data: [64]Word8
	datalen: Nat32
	bitlen: Nat64
	state: [8]Word32
}


//@inline
//func rotleft(a: Word32, b: Nat32) -> Word32 {
//	return (a << b) or (a >> (32 - b))
//}


@inline
func rotright (a: Word32, b: Nat32) -> Word32 {
	return (a >> b) or (a << (32 - b))
}



@inline
func ch (x: Word32, y: Word32, z: Word32) -> Word32 {
	return (x and y) xor (not x and z)
}



@inline
func maj (x: Word32, y: Word32, z: Word32) -> Word32 {
	return (x and y) xor (x and z) xor (y and z)
}



@inline
func ep0 (x: Word32) -> Word32 {
	return rotright(x, 2) xor rotright(x, 13) xor rotright(x, 22)
}



@inline
func ep1 (x: Word32) -> Word32 {
	return rotright(x, 6) xor rotright(x, 11) xor rotright(x, 25)
}



@inline
func sig0 (x: Word32) -> Word32 {
	return rotright(x, 7) xor rotright(x, 18) xor (x >> 3)
}



@inline
func sig1 (x: Word32) -> Word32 {
	return rotright(x, 17) xor rotright(x, 19) xor (x >> 10)
}



const initalState = [
	0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A
	0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19
]


func contextInit (ctx: *Context) -> Unit {
	ctx.state = initalState
}


const k = [
	0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5
	0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5
	0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3
	0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174
	0xE49B69C1, 0xEFBE4786, 0x0FC19DC6, 0x240CA1CC
	0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA
	0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7
	0xC6E00BF3, 0xD5A79147, 0x06CA6351, 0x14292967
	0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13
	0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85
	0xA2BFE8A1, 0xA81A664B, 0xC24B8B70, 0xC76C51A3
	0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070
	0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5
	0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3
	0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208
	0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2
]


func transform (ctx: *Context, data: *[]Word8) -> Unit {
	var m = [64]Word32 []

	var i = Nat32 0
	var j = Nat32 0

	while i < 16 {
		let x: Word32 = (Word32 data[j + 0] << 24) or (Word32 data[j + 1] << 16) or (Word32 data[j + 2] << 08) or (Word32 data[j + 3] << 00)

		m[i] = x
		j = j + 4
		i = i + 1
	}

	while i < 64 {
		m[i] = Word32 (Nat32 sig1(m[i - 2]) + Nat32 m[i - 7] + Nat32 sig0(m[i - 15]) + Nat32 m[i - 16])
		i = i + 1
	}

	var x: [8]Word32 = ctx.state

	i = 0
	while i < 64 {
		let t1: Nat32 = Nat32 x[7] + Nat32 ep1(x[4]) + Nat32 ch(x[4], x[5], x[6]) + Nat32 k[i] + Nat32 m[i]
		let t2: Nat32 = Nat32 ep0(x[0]) + Nat32 maj(x[0], x[1], x[2])

		x[7] = x[6]
		x[6] = x[5]
		x[5] = x[4]
		x[4] = Word32 (Nat32 x[3] + t1)
		x[3] = x[2]
		x[2] = x[1]
		x[1] = x[0]
		x[0] = Word32 (t1 + t2)

		i = i + 1
	}

	i = 0
	while i < 8 {
		ctx.state[i] = Word32 (Nat32 ctx.state[i] + Nat32 x[i])
		i = i + 1
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
		i = i + 1
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

	i = i + 1

	memset(&ctx.data[i], 0, SizeT (n - i))
	//ctx.data[i:n-i] = []

	if ctx.datalen >= 56 {
		transform(ctx, &ctx.data)
		memset(&ctx.data, 0, 56)
		//ctx.data[0:56] = []
	}

	// Append to the padding the total message's length in bits and transform.
	ctx.bitlen = ctx.bitlen + Nat64 ctx.datalen * 8

	ctx.data[63] = unsafe Word8 (unsafe Word64 ctx.bitlen >> 00)
	ctx.data[62] = unsafe Word8 (unsafe Word64 ctx.bitlen >> 08)
	ctx.data[61] = unsafe Word8 (unsafe Word64 ctx.bitlen >> 16)
	ctx.data[60] = unsafe Word8 (unsafe Word64 ctx.bitlen >> 24)
	ctx.data[59] = unsafe Word8 (unsafe Word64 ctx.bitlen >> 32)
	ctx.data[58] = unsafe Word8 (unsafe Word64 ctx.bitlen >> 40)
	ctx.data[57] = unsafe Word8 (unsafe Word64 ctx.bitlen >> 48)
	ctx.data[56] = unsafe Word8 (unsafe Word64 ctx.bitlen >> 56)

	transform(ctx, &ctx.data)

	// Since this implementation uses little endian byte ordering
	// and SHA uses big endian, reverse all the bytes
	// when copying the final state to the output hash.

	i = 0
	while i < 4 {
		let sh: Nat32 = 24 - i * 8
		outHash[i + 00] = unsafe Word8 (ctx.state[0] >> sh)
		outHash[i + 04] = unsafe Word8 (ctx.state[1] >> sh)
		outHash[i + 08] = unsafe Word8 (ctx.state[2] >> sh)
		outHash[i + 12] = unsafe Word8 (ctx.state[3] >> sh)
		outHash[i + 16] = unsafe Word8 (ctx.state[4] >> sh)
		outHash[i + 20] = unsafe Word8 (ctx.state[5] >> sh)
		outHash[i + 24] = unsafe Word8 (ctx.state[6] >> sh)
		outHash[i + 28] = unsafe Word8 (ctx.state[7] >> sh)
		i = i + 1
	}
}


public func hash (msg: *[]Word8, msgLen: Nat32, outHash: *Hash) -> Unit {
	var ctx: Context = Context {}
	contextInit(&ctx)
	update(&ctx, msg, msgLen)
	final(&ctx, outHash)
}

