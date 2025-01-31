
@c_include "time.h"


public func us(us: Nat64) -> Unit {
	let start_time = time.clock()
	while time.clock() < start_time + us {
		// just waiting
	}
}


public func ms(ms: Nat64) -> Unit {
	us(ms * 1000)
}


public func sec(s: Nat64) -> Unit {
	us(s * 1000000)
}

