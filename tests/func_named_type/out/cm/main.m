import "builtin"
include "ctypes64"
include "stdio"

include "libc/ctypes64"
include "libc/stdio"

type FailHandler = (code: Int32) -> Unit

func onDiskFail: FailHandler {
	printf("disk failed with code %d\n", code)
}

func onNetworkFail: FailHandler {
	printf("network failed with code %d\n", code)
}

@nonstatic
func main () -> Int {
	onDiskFail(1)
	onNetworkFail(2)
	return 0
}

