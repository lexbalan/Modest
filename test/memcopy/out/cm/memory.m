
//
//
const systemWidth = 64
//$if (systemWidth == 64)
type Word Word64
type Nat Nat64
//$elseif (systemWidth == 32)
//type Word Word32
//type Nat Nat32
//$endif
const memoryAlignment = systemWidth / 8
public func mzero(mem: Ptr, len: Nat64) -> Unit {
	let z = Nat mem % memoryAlignment

	let memptr = mem

	let dst_byte0 = memptr

	// align the pointer
	var i: Nat64 = Nat64 0
	while i < z {
		dst_byte0[i] = 0
		i = i + 1
	}

	// word operation

	let len_words = (len - z) / sizeof(Word)
	let dst_word = *[]Word &memptr[i]

	i = 0
	while i < len_words {
		dst_word[i] = 0
		i = i + 1
	}

	// byte operation

	let len_bytes = (len - z) % sizeof(Word)
	let dst_byte1 = *[]Word8 &dst_word[i]

	i = 0
	while i < len_bytes {
		dst_byte1[i] = 0
		i = i + 1
	}
}
public func mcopy(dst: Ptr, src: Ptr, len: Nat64) -> Unit {
	let len_words = len / sizeof(Word)
	let src_w = src
	let dst_w = dst

	var i: Nat64 = Nat64 0
	while i < len_words {
		dst_w[i] = src_w[i]
		i = i + 1
	}

	let len_bytes = len % sizeof(Word)
	let src_b = *[]Word8 &src_w[i]
	let dst_b = *[]Word8 &dst_w[i]

	i = 0
	while i < len_bytes {
		dst_b[i] = src_b[i]
		i = i + 1
	}
}
public func meq(mem0: Ptr, mem1: Ptr, len: Nat64) -> Bool {
	let len_words = len / sizeof(Word)
	let mem0_w = mem0
	let mem1_w = mem1

	var i: Nat64 = Nat64 0
	while i < len_words {
		if mem0_w[i] != mem1_w[i] {
			return false
		}
		i = i + 1
	}

	let len_bytes = len % sizeof(Word)
	let mem0_b = *[]Word8 &mem0_w[i]
	let mem1_b = *[]Word8 &mem1_w[i]

	i = 0
	while i < len_bytes {
		if mem0_b[i] != mem1_b[i] {
			return false
		}
		i = i + 1
	}

	return true
}
