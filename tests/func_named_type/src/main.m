// tests/func_named_type/src/main.m
//
// EXPERIMENTAL: `func <name>: <FuncType> { ... }` — the parameter list and
// return type are borrowed from a named function type instead of being
// spelled out inline. See docs/lang/def/func.md.

include "libc/ctypes64"
include "libc/stdio"

type FailHandler = (code: Int32) -> Unit

func onDiskFail: FailHandler {
	printf("disk failed with code %d\n", code)
}

func onNetworkFail: FailHandler {
	printf("network failed with code %d\n", code)
}

func main () -> Int {
	onDiskFail(1)
	onNetworkFail(2)
	return 0
}
