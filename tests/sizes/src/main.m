// tests/sizes/src/main.m

include "libc/ctypes64"
include "libc/stdio"


public func main () -> Int {
    printf("sizeof(char) = %zu\n", SizeT sizeof(Char))
    printf("sizeof(short) = %zu\n", SizeT sizeof(Short))
    printf("sizeof(int) = %zu\n", SizeT sizeof(Int))
    printf("sizeof(long) = %zu\n", SizeT sizeof(Long))
    printf("sizeof(long long) = %zu\n", SizeT sizeof(LongLong))
    printf("sizeof(size_t) = %zu\n", SizeT sizeof(SizeT))
    printf("sizeof(void*) = %zu\n", SizeT sizeof(*Unit))
	return 0
}

