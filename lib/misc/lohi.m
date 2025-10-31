// lohi.m


public func lo16(x: Word16) -> Word8 {
	return Word8 (x and 0xFF)
}


public func hi16(x: Word16) -> Word8 {
	return Word16 (x >> 8)
}


public func lo32(x: Word32) -> Word16 {
	return Word16 (x and 0xFFFF)
}


public func hi32(x: Word32) -> Word16 {
	return Word16 (x >> 16)
}


public func lo64(x: Word64) -> Word32 {
	return Word32 (x and 0xFFFFFFFF)
}


public func hi64(x: Word64) -> Word32 {
	return Word32 (x >> 32)
}


public func lo128(x: Word128) -> Word64 {
	return Word64 (x and 0xFFFFFFFFFFFFFFFF)
}


public func hi128(x: Word128) -> Word64 {
	return Word64 (x >> 64)
}

