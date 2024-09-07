// test/pre/src/main.cm

//import "libc/stdio"


$pragma c_include "stdio.h"

@attribute("c-no-print")
export func printf(s: *Str8, ...)


func main() -> Int {
	let a = 10
	let b = 20
	let s = mid(a, b)
	printf("s = %d\n", s)

	return 0
}

