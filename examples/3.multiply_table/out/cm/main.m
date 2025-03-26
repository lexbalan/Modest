
@c_include "stdio.h"


func mtab(n: Nat32) -> Unit {
	var m: Nat32 = 1
	// or
	//var m = 1   // by default integer var get system int type (-mint option)
	while m < 10 {
		let nm = n * m
		stdio.("%u * %u = %u\n", n, m, nm)
		m = m + 1
	}
}


public func main() -> Int {
	let n = 2 * 2
	stdio.("multiply table for %d\n", Int32 n)
	mtab(n)
	return 0
}

