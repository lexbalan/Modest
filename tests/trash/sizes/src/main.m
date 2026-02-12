// tests/sizes/src/main.m

include "libc/ctypes64"
include "libc/stdio"


pragma insert "#define CDECL"
pragma insert "CDECL"


public func main () -> Int {
    printf("sizeof(Char) = %zu\n", sizeof(Char))
    printf("sizeof(Short) = %zu\n", sizeof(Short))
    printf("sizeof(Int) = %zu\n", sizeof(Int))
    printf("sizeof(Long) = %zu\n", sizeof(Long))
    printf("sizeof(LongLong) = %zu\n", sizeof(LongLong))
    printf("sizeof(Size) = %zu\n", sizeof(SizeT))
    printf("sizeof(*Unit) = %zu\n", sizeof(*Unit))
	return 0
}

