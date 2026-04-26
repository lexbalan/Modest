// tests/chacha20/src/main.m

pragma unsafe

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"

import "misc/chacha20" as cc


type Context = {
	key: *[32]Byte
	nonce: [3]Word32
	blockCounter: Nat32
	block: cc.Block
	blockOffset: Nat32
}


func init (key: *[32]Byte, nonce: [3]Word32) -> Context {
	return {
		key = key
		nonce = [nonce[0], nonce[1], nonce[2]]
		blockCounter = 0
		blockOffset = unsafe Nat32 sizeof(cc.Block)
	}
}


func cipher (ctx: *Context, data: *[]Byte, len: Nat32) -> Unit {
	var i = Nat32 0
	var bptr = *[]Byte nil
	while i < len {
		if ctx.blockOffset == unsafe Nat32 sizeof(cc.Block) {
			var state = cc.makeState(
				key = unsafe *cc.Key ctx.key
				counter = Word32 ctx.blockCounter
				nonce = &ctx.nonce
			)
			state[13:16] = ctx.nonce[0:3]

			ctx.block = cc.chacha20Block(state)
			ctx.blockOffset = 0
			bptr = unsafe *[]Byte &ctx.block
		}

		data[i] = data[i] ^ bptr[ctx.blockOffset]

		++ctx.blockOffset
		++i
	}
}


var testKey = [32]Byte [
	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
]

var testNonce = [12]Byte [
	0x00, 0x00, 0x00, 0x09,
	0x00, 0x00, 0x00, 0x4a,
	0x00, 0x00, 0x00, 0x00,
]

var testNonce2 = [3]Word32 [
	0x00000009,
	0x0000004a,
	0x00000000,
]

const testResult = [64]Byte [
	0x10, 0xf1, 0xe7, 0xe4, 0xd1, 0x3b, 0x59, 0x15,
	0x50, 0x0f, 0xdd, 0x1f, 0xa3, 0x20, 0x71, 0xc4,
	0xc7, 0xd1, 0xf4, 0xc7, 0x33, 0xc0, 0x68, 0x03,
	0x04, 0x22, 0xaa, 0x9a, 0xc3, 0xd4, 0x6c, 0x4e,
	0xd2, 0x82, 0x64, 0x46, 0x07, 0x9f, 0xaa, 0x09,
	0x14, 0xc2, 0xd7, 0x05, 0xd9, 0x8b, 0x02, 0xa2,
	0xb5, 0x12, 0x9c, 0xd1, 0xde, 0x16, 0x4e, 0xb9,
	0xcb, 0xd0, 0x83, 0xe8, 0xa2, 0x50, 0x3c, 0x4e,
]



const lorem1024 = [1024]Char8 "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit ve"

var xlorem1024 = lorem1024


func main () -> Int {
	printf("test ChaCha20 ")
	//printf("%s\n", *Str8 hello_world)
	//var data = []Byte [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	var ctx = init(&testKey, testNonce2)
	let dptr = unsafe *[]Byte &xlorem1024
	cipher(&ctx, dptr, 1024)

	var i = 0
//	while i < 10 {
//		printf("%c", xlorem1024[i])
//		printf("%x\n", Nat32 Word32 Word8 xlorem1024[i])
//		++i
//	}

	var ctx2 = init(&testKey, testNonce2)
	cipher(&ctx2, dptr, 1024)

	i = 0
	while i < 1024 {
		printf("%c", xlorem1024[i])
		++i
	}

	if not test0() {
		printf("fail\n")
		return exitFailure
	}

	printf("success\n")
	return exitSuccess
}


func test0 () -> Bool {
	var key: [32]Byte = testKey
	var counter: Word32 = 1
	var nonce: [12]Byte = testNonce
	var state = cc.makeState(unsafe *cc.Key &key, counter, unsafe *[3]Word32 &nonce)
	var block = cc.chacha20Block(state)

//	var i = 0
//	while i < 16 {
//		printf("%08x\n", block[i])
//		++i
//	}

	let bptr = unsafe *[64]Byte &block

	return *bptr == testResult
}


