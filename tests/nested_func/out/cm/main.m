import "builtin"
include "ctypes64"
include "stdio"

include "libc/ctypes64"
include "libc/stdio"


@nonstatic
func main () -> Int {

	type MyInt = Int

	func local () -> Unit {
		var x: Int32
		x = 1
		printf("hello from 'local' func!\n")
	}

	local()

	return 0
}

