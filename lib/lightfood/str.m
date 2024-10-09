// lightfood/str.m


public func len8(str: *Str8) -> Nat64 {
	var i = Nat64 0
	while str[i] != "\0" {
		++i
	}
	return i
}


public func len16(str: *Str16) -> Nat64 {
	var i = Nat64 0
	while str[i] != "\0" {
		++i
	}
	return i
}


public func len32(str: *Str32) -> Nat64 {
	var i = Nat64 0
	while str[i] != "\0" {
		++i
	}
	return i
}

