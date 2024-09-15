// lightfood/delay.m

include "libc/time"


export func delay_us(us: Nat64) {
	let start_time = clock()
	while (clock() < start_time + us) {
		// just waiting
	}
}


export func delay(us: Nat64) {
	delay_us(us)
}


export func delay_ms(ms: Nat64) {
	delay_us(ms * 1000)
}


export func delay_s(s: Nat64) {
	delay_ms(s * 1000)
}


