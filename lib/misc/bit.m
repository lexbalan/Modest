// bit.m

//
// 32-bit
//

func bit_set32(x: Nat32, bit_no: Nat8) -> Nat32 {
	let mask = Nat32 1 << bit_no
	return x or mask
}


func bit_reset32(x: Nat32, bit_no: Nat8) -> Nat32 {
	let mask = Nat32 1 << bit_no
	return x and not mask
}


func bit_switch32(x: Nat32, bit_no: Nat8, bitval: Bool) -> Nat32 {
	if bitval {
		return bit_set32(x, bit_no)
	} else {
		return bit_reset32(x, bit_no)
	}
	return 0
}


func bit_check32(x: Nat32, bit_no: Nat8) -> Bool {
	let mask = Nat32 1 << bit_no
	return Bool (x and mask)
}


//
// 64-bit
//

func bit_set64(x: Nat64, bit_no: Nat8) -> Nat64 {
	let mask = Nat64 1 << bit_no
	return x or mask
}


func bit_reset64(x: Nat64, bit_no: Nat8) -> Nat64 {
	let mask = Nat64 1 << bit_no
	return x and not mask
}


func bit_switch64(x: Nat64, bit_no: Nat8, bitval: Bool) -> Nat64 {
	if bitval {
		return bit_set64(x, bit_no)
	} else {
		return bit_reset64(x, bit_no)
	}
	return 0
}


func bit_check64(x: Nat64, bit_no: Nat8) -> Bool {
	let mask = Nat64 1 << bit_no
	return Bool (x and mask)
}


