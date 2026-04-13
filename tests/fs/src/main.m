// tests/0/src/main.m

include "libc/ctypes64"
include "libc/stdio"

include "./sys"


public func main () -> Int32 {
	//chdir("/")

	init()

	let fd = open("/storage/sd/hello.txt", 0)
	if fd < 0 {
		printf("cannot open file (error = %d)\n", fd)
		return -1
	}

	close(fd)

	return 0
}
