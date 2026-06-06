import "builtin"
include "ctypes64"
include "stdio"

include "libc/ctypes64"
include "libc/stdio"


@nonstatic
func main () -> Int {

	type MyInt = Int
	var x: MyInt = 0
	Unit x
	func local () -> Unit {
		var x: Int32
		x = 1
		Unit x
		printf("hello from 'local' func!\n")
	}

	local()

	return 0
}

