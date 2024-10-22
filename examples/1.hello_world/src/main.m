// examples/1.hello_world/src/main.cm

include "libc/ctypes64"
include "libc/stdio"

public func main() -> Int {
	printf("Hello World!\n")
	return 0
}

