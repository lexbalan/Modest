// tests/0/src/main.m

include "libc/ctypes64"
include "libc/stdio"

import "./sys"


public func main () -> Int32 {
	//chdir("/")

	sys.init()

	let fd = sys.open("/storage/sd/hello.txt", 0)
	if fd < 0 {
		printf("cannot open file (error = %d)\n", fd)
		return -1
	}

	sys.close(fd)

	return 0
}
