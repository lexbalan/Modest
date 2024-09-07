// test/pre0/src/main.cm

import "lib"

$pragma c_include "stdio.h"


func main() -> lib.Int {
	let a = 10
	let b = 20
	let s = lib.mid(a, b)
	printf("s = %d\n", s)

	// access to private value
	//let x = lib.div(a, b)

	return 0
}


@attribute("c-no-print")
func printf(s: *Str8, ...)

