// tests/0/src/main.m

include "libc/ctypes64"
include "libc/stdio"


func main () -> Int {
	var arr: [10]Int32
	let p = &arr[2:]
	return 0
}
