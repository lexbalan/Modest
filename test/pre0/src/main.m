// test/pre/src/main.cm


import "lib"

$pragma c_include "stdio.h"

@attribute("c-no-print")
export func printf(s: *Str8, ...)


func main() -> lib.Int {
	let a = 10
	let b = 20
	let s = lib.mid(a, b)
	printf("s = %d\n", s)

	lib.internal_func()

	return 0
}

