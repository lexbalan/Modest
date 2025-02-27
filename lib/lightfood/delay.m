// lightfood/delay.m

$pragma do_not_include

include "libc/time"


public func us(us: Nat64) {
	let start_time = clock()
	while clock() < start_time + us {
		// just waiting
	}
}


public func ms(ms: Nat64) {
	us(ms * 1000)
}


public func sec(s: Nat64) {
	us(s * 1000000)
}


