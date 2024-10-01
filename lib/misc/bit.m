// bit.m

type Word8 Nat8
type Word16 Nat16
type Word32 Nat32
type Word64 Nat64
type Word128 Nat128


//
// 8-bit
//

@inline
func set8(x: Word8, no: Nat8) -> Word8 {
	let mask = Word8 1 << no
	return x or mask
}


@inline
func reset8(x: Word8, no: Nat8) -> Word8 {
	let mask = Word8 1 << no
	return x and not mask
}


func switch8(x: Word8, no: Nat8, val: Bool) -> Word8 {
	if val {
		return set16(x, no)
	} else {
		return reset16(x, no)
	}
	return 0
}

@inline
func check8(x: Word8, no: Nat8) -> Bool {
	let mask = Word8 1 << no
	return Bool (x and mask)
}


//
// 16-bit
//

@inline
func set16(x: Word16, no: Nat8) -> Word16 {
	let mask = Word16 1 << no
	return x or mask
}


@inline
func reset16(x: Word16, no: Nat8) -> Word16 {
	let mask = Word16 1 << no
	return x and not mask
}


func switch16(x: Word16, no: Nat8, val: Bool) -> Word16 {
	if val {
		return set16(x, no)
	} else {
		return reset16(x, no)
	}
	return 0
}

@inline
func check16(x: Word16, no: Nat8) -> Bool {
	let mask = Word16 1 << no
	return Bool (x and mask)
}


//
// 32-bit
//

@inline
func set32(x: Word32, no: Nat8) -> Word32 {
	let mask = Word32 1 << no
	return x or mask
}


@inline
func reset32(x: Word32, no: Nat8) -> Word32 {
	let mask = Word32 1 << no
	return x and not mask
}


func switch32(x: Word32, no: Nat8, val: Bool) -> Word32 {
	if val {
		return set32(x, no)
	} else {
		return reset32(x, no)
	}
	return 0
}

@inline
func check32(x: Word32, no: Nat8) -> Bool {
	let mask = Word32 1 << no
	return Bool (x and mask)
}


//
// 64-bit
//

@inline
func set64(x: Word64, no: Nat8) -> Word64 {
	let mask = Word64 1 << no
	return x or mask
}

@inline
func reset64(x: Word64, no: Nat8) -> Word64 {
	let mask = Word64 1 << no
	return x and not mask
}


func switch64(x: Word64, no: Nat8, val: Bool) -> Word64 {
	if val {
		return set64(x, no)
	} else {
		return reset64(x, no)
	}
	return 0
}

@inline
func check64(x: Word64, no: Nat8) -> Bool {
	let mask = Word64 1 << no
	return Bool (x and mask)
}


//
// 128-bit
//

@inline
func set128(x: Word128, no: Nat8) -> Word128 {
	let mask = Word128 1 << no
	return x or mask
}

@inline
func reset128(x: Word128, no: Nat8) -> Word128 {
	let mask = Word128 1 << no
	return x and not mask
}


func switch128(x: Word128, no: Nat8, val: Bool) -> Word128 {
	if val {
		return set64(x, no)
	} else {
		return reset64(x, no)
	}
	return 0
}

@inline
func check128(x: Word128, no: Nat8) -> Bool {
	let mask = Word128 1 << no
	return Bool (x and mask)
}

