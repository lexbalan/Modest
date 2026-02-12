import "misc/chacha20"
include "ctypes64"
include "stdio"
include "stdlib"

import "misc/chacha20" as cc


type Context = record {
	key: *[32]Byte
	nonce: [3]Word32
	blockCounter: Nat32
	block: Block
	blockOffset: Nat32
}


func init (key: *[32]Byte, nonce: [3]Word32) -> Context {
	return {
		key = key
		nonce = [nonce[0], nonce[1], nonce[2]]
		blockCounter = 0
		blockOffset = unsafe Nat32 sizeof(Block)
	}
}


func cipher (ctx: *Context, data: *[]Byte, len: Nat32) -> Unit {
	var i = Nat32 0
	var bptr = *[]Byte nil
	while i < len {
		// Нужно сгенерировать новый блок?
		if ctx.blockOffset == unsafe Nat32 sizeof(Block) {
			//printf("UH!\n")
			var state: State = cc.makeState(key=unsafe *Key ctx.key, counter=Word32 ctx.blockCounter, nonce=&ctx.nonce)
			state[13:16] = ctx.nonce[0:3]
			//state[13] = ctx.nonce[0]
			//state[14] = ctx.nonce[1]
			//state[15] = ctx.nonce[2]

			ctx.block = cc.chacha20Block(state)
			ctx.blockOffset = 0
			bptr = unsafe *[]Byte &ctx.block
		}

		data[i] = data[i] xor bptr[ctx.blockOffset]

		ctx.blockOffset = ctx.blockOffset + 1
		i = i + 1
	}
}


var testKey = [32]Byte [
	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
	0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17
	0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F
]

var testNonce = [12]Byte [
	0x00, 0x00, 0x00, 0x09
	0x00, 0x00, 0x00, 0x4A
]

var testNonce2 = [3]Word32 [
	0x00000009
	0x0000004A
]

const testResult = [64]Byte [
	0x10, 0xF1, 0xE7, 0xE4, 0xD1, 0x3B, 0x59, 0x15
	0x50, 0x0F, 0xDD, 0x1F, 0xA3, 0x20, 0x71, 0xC4
	0xC7, 0xD1, 0xF4, 0xC7, 0x33, 0xC0, 0x68, 0x03
	0x04, 0x22, 0xAA, 0x9A, 0xC3, 0xD4, 0x6C, 0x4E
	0xD2, 0x82, 0x64, 0x46, 0x07, 0x9F, 0xAA, 0x09
	0x14, 0xC2, 0xD7, 0x05, 0xD9, 0x8B, 0x02, 0xA2
	0xB5, 0x12, 0x9C, 0xD1, 0xDE, 0x16, 0x4E, 0xB9
	0xCB, 0xD0, 0x83, 0xE8, 0xA2, 0x50, 0x3C, 0x4E
]



const lorem1024 = [1024]Char8 "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit ve"

var xlorem1024: [1024]Char8 = lorem1024


public func main () -> Int {
	printf("test ChaCha20 ")
	//printf("%s\n", *Str8 hello_world)
	//var data = []Byte [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	var ctx: Context = init(&testKey, testNonce2)
	let dptr: *[]Byte = unsafe *[]Byte &xlorem1024
	cipher(&ctx, dptr, 1024)

	var i: Int32 = 0
	while i < 10 {
		printf("%c", xlorem1024[i])
		printf("%x\n", Nat32 Word32 Word8 xlorem1024[i])
		i = i + 1
	}

	var ctx2: Context = init(&testKey, testNonce2)
	cipher(&ctx2, dptr, 1024)

	i = 0
	while i < 1024 {
		printf("%c", xlorem1024[i])
		i = i + 1
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
	var state: State = cc.makeState(unsafe *Key &key, counter, unsafe *[3]Word32 &nonce)
	var block: Block = cc.chacha20Block(state)

	var i: Int32 = 0
	while i < 16 {
		printf("%08x\n", block[i])
		i = i + 1
	}

	let bptr: *[64]Byte = unsafe *[64]Byte &block

	return *bptr == testResult
}

