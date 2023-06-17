
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

int32_t main() {
	printf("if-else example\n");
	int32_t a;
	int32_t b;
	printf("enter a: ");
	scanf("%d", &a);
	printf("enter b: ");
	scanf("%d", &b);
	if(a > b) {
		printf("a > b\n");
	} else if(a < b) {
		printf("a < b\n");
	} else {
		printf("a == b\n");
	}
	return 0;
}

