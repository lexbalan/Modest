// lightfood/str.m


func len8(str: *Str8) -> Nat64 {
	var i = Nat64 0
	while str[i] != "\0" {
		++i
	}
	return i
}


func len16(str: *Str16) -> Nat64 {
	var i = Nat64 0
	while str[i] != "\0" {
		++i
	}
	return i
}


func len32(str: *Str32) -> Nat64 {
	var i = Nat64 0
	while str[i] != "\0" {
		++i
	}
	return i
}

