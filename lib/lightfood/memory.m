// lightfood/memory.m

$pragma do_not_include


let systemWidth = 64


$if (systemWidth == 64)
type Word Word64
$elseif (systemWidth == 32)
type Word Word32
$endif


let memoryAlignment = systemWidth / 8


func memzero(mem: Ptr, len: Nat64) {
	let z = Word mem % memoryAlignment

	// align the pointer
	var i = Nat64 0
	while i < z {
		dst_byte0[i] = 0
		++i
	}

	// word operation

	let len_words = (len - z) / sizeof(Word)
	let dst_word = *[]Word &mem[i]

	i = 0
	while i < len_words {
		dst_word[i] = 0
		++i
	}

	// byte operation

	let len_bytes = (len - z) % sizeof(Word)
	let dst_byte1 = *[]Byte &dst_word[i]

	i = 0
	while i < len_bytes {
		dst_byte1[i] = 0
		++i
	}
}


func memcopy(dst: Ptr, src: Ptr, len: Nat64) {
	let len_words = len / sizeof(Word)
	let src_w = *[]Word src
	let dst_w = *[]Word dst

	var i = Nat64 0
	while i < len_words {
		dst_w[i] = src_w[i]
		++i
	}

	let len_bytes = len % sizeof(Word)
	let src_b = *[]Byte &src_w[i]
	let dst_b = *[]Byte &dst_w[i]

	i = 0
	while i < len_bytes {
		dst_b[i] = src_b[i]
		++i
	}
}


func memeq(mem0: Ptr, mem1: Ptr, len: Nat64) -> Bool {
	let len_words = len / sizeof(Word)
	let mem0_w = *[]Word mem0
	let mem1_w = *[]Word mem1

	var i = Nat64 0
	while i < len_words {
		if mem0_w[i] != mem1_w[i] {
			return false
		}
		++i
	}

	let len_bytes = len % sizeof(Word)
	let mem0_b = *[]Byte &mem0_w[i]
	let mem1_b = *[]Byte &mem1_w[i]

	i = 0
	while i < len_bytes {
		if mem0_b[i] != mem1_b[i] {
			return false
		}
		++i
	}

	return true
}

