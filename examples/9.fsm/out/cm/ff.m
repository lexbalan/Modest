
include "libc/time"
export func us(us: Nat64) -> Unit {
	let start_time = clock()
	while clock() < start_time + us {
		// just waiting
	}
}
export func ms(ms: Nat64) -> Unit {
	us(ms * 1000)
}
export func sec(s: Nat64) -> Unit {
	us(s * 1000000)
}

