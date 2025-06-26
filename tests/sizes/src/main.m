// tests/sizes/src/main.m

include "libc/ctypes64"
include "libc/stdio"


public func main () -> Int {
    printf("sizeof(char) = %zu\n", sizeof(Char))
    printf("sizeof(short) = %zu\n", sizeof(Short))
    printf("sizeof(int) = %zu\n", sizeof(Int))
    printf("sizeof(long) = %zu\n", sizeof(Long))
    printf("sizeof(long long) = %zu\n", sizeof(LongLong))
    printf("sizeof(size_t) = %zu\n", sizeof(SizeT))
    printf("sizeof(void*) = %zu\n", sizeof(*Unit))
	return 0
}

