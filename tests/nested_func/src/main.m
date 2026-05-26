// tests/nested_func/src/main.m

include "libc/ctypes64"
include "libc/stdio"


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
