// lightfood/delay.m

$pragma do_not_include

include "libc/time"


export func us(us: Nat64) {
	let start_time = clock()
	while (clock() < start_time + us) {
		// just waiting
	}
}


export func ms(ms: Nat64) {
	us(ms * 1000)
}


export func sec(s: Nat64) {
	us(s * 1000000)
}


