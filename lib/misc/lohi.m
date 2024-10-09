// lohi.m

//
// Unsigned
//

public func lo_nat16(x: Nat16) -> Nat8 {
	return Nat8 (x and 0xFF)
}


public func hi_nat16(x: Nat16) -> Nat8 {
	return Nat16 (x >> 8)
}


public func lo_nat32(x: Nat32) -> Nat16 {
	return Nat16 (x and 0xFFFF)
}


public func hi_nat32(x: Nat32) -> Nat16 {
	return Nat16 (x >> 16)
}


public func lo_nat64(x: Nat64) -> Nat32 {
	return Nat32 (x and 0xFFFFFFFF)
}


public func hi_nat64(x: Nat64) -> Nat32 {
	return Nat32 (x >> 32)
}


public func lo_nat128(x: Nat128) -> Nat64 {
	return Nat64 (x and 0xFFFFFFFFFFFFFFFF)
}


public func hi_nat128(x: Nat128) -> Nat64 {
	return Nat64 (x >> 64)
}


//
// Signed
//

public func lo_int16(x: Int16) -> Int8 {
	return Int8 (x and 0xFF)
}


public func hi_int16(x: Int16) -> Int8 {
	return Int16 (x >> 8)
}


public func lo_int32(x: Int32) -> Int16 {
	return Int16 (x and 0xFFFF)
}


public func hi_int32(x: Int32) -> Int16 {
	return Int16 (x >> 16)
}


public func lo_int64(x: Int64) -> Int32 {
	return Int32 (x and 0xFFFFFFFF)
}


public func hi_int64(x: Int64) -> Int32 {
	return Int32 (x >> 32)
}


public func lo_int128(x: Int128) -> Int64 {
	return Int64 (x and 0xFFFFFFFFFFFFFFFF)
}


public func hi_int128(x: Int128) -> Int64 {
	return Int64 (x >> 64)
}

