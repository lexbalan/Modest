
#include <stdint.h>

typedef int8_t Char;
typedef int8_t ConstChar;
typedef int8_t SignedChar;
typedef uint8_t UnsignedChar;
typedef int16_t Short;
typedef uint16_t UnsignedShort;
typedef int32_t Int;
typedef uint32_t UnsignedInt;
typedef int64_t LongInt;
typedef uint64_t UnsignedLongInt;
typedef int64_t Long;
typedef uint64_t UnsignedLong;
typedef int64_t LongLong;
typedef uint64_t UnsignedLongLong;
typedef float Float;
typedef double Double;
typedef double LongDouble;
typedef uint64_t SizeT;
typedef int64_t SSizeT;

#include <stdio.h>

void mtab(uint32_t n) {
	uint32_t m;
	m = 1;
	while(m < 10) {
		uint32_t nm = n * m;
		printf("%d * %d = %d\n", n, m, nm);
		m = m + 1;
	}
}

int32_t main() {
	Int n = 2;
	printf("multiply table for %d\n", n);
	mtab(n);
	return 0;
}

