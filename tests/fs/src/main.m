// tests/0/src/main.m

pragma unsafe

include "libc/ctypes64"
include "libc/stdio"
include "libc/fcntl"
include "libc/stat"
include "libc/unistd"

import "./sys"


public func main () -> Int32 {
	var buf1: [32]Char8
	var buf2: [32]Char8

	sys.init()

	var rc: Int
	rc = sys.mkdir("/A/p")
	if rc != 0 {
		printf("cannot create directory %d\n", rc)
	}

	let fd = sys.open("/A/hello.txt", c_O_RDWR)
	if fd < 0 {
		printf("cannot open file (error = %d)\n", fd)
		return -1
	}

	// write file
	buf1 = "Hello World!"
	sys.write(fd, unsafe *[]Byte &buf1, 32)

	// read file
	sys.lseek(fd, 0, c_SEEK_SET)
	sys.read(fd, unsafe *[]Byte &buf2, 32)

	printf("buf2 = \"%s\"\n", &buf2)

	sys.close(fd)

	sys.deinit()

	return 0
}
