
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#ifndef __STR_UNICODE__
#if __has_include(<uchar.h>)
#include <uchar.h>
#else
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#endif
#define __STR_UNICODE__
#define __STR8(x)  x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x)  __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#define _CHR8(x)  (__STR8(x)[0])
#define _CHR16(x) (__STR16(x)[0])
#define _CHR32(x) (__STR32(x)[0])
#endif /* __STR_UNICODE__ */





struct point {
	uint32_t x;
	uint32_t y;
};


struct mixed1 {
	char c;
	int32_t i;
	double f;
};


struct mixed2 {
	int32_t i;
	char c;
	double f;
	char c2[3];
	struct mixed1 m;
};


struct mixed3 {
	char c;
	int32_t i;
	double f;
	char c2[9];
};


struct mixed4 {
	struct mixed2 s;
	char c;
	int32_t i;
	double f;
	char c2[9];
	int16_t i2;
	struct point p[3];
	struct mixed3 s2;
};


//var s: Mixed2
static char c;
static int32_t i;
static double f;
static int16_t i2;
static struct point p[3];
static bool g;


struct x {
	char c;
	int32_t i;
	double f;
	int16_t i2;
	struct point p[3];
	bool g;
};

static struct x x;

int main(void) {
	printf("test cast operation\n");

	const uint64_t start_adr = (uint64_t)&c;
	printf("off(c) = %llu\n", (uint64_t)&c - start_adr);
	printf("off(i) = %llu\n", (uint64_t)&i - start_adr);
	printf("off(f) = %llu\n", (uint64_t)&f - start_adr);
	printf("off(i2) = %llu\n", (uint64_t)&i2 - start_adr);
	printf("off(p) = %llu\n", (uint64_t)&p - start_adr);
	printf("off(g) = %llu\n", (uint64_t)&g - start_adr);

	// дженерики в с явно не приводятся, но нектороые нужно!
	//	printf("offsetof(x.c) = %llu\n", Nat64 offsetof(X.c))
	//	printf("offsetof(x.i) = %llu\n", Nat64 offsetof(X.i))
	//	printf("offsetof(x.f) = %llu\n", Nat64 offsetof(X.f))
	//	printf("offsetof(x.i2) = %llu\n", Nat64 offsetof(X.i2))
	//	printf("offsetof(x.p) = %llu\n", Nat64 offsetof(X.p))
	//	printf("offsetof(x.g) = %llu\n", Nat64 offsetof(X.g))


	// sizeof(void) in C  == 1
	// sizeof(Unit) in CM == 0
	// TODO: here is a broblem
	printf("sizeof(Unit) = %zu\n", (/*sizeof(void)*/(size_t)0));
	printf("alignof(Unit) = %zu\n", (/*alignof(void)*/(size_t)1));

	printf("sizeof(Bool) = %zu\n", sizeof(bool));
	printf("alignof(Bool) = %zu\n", __alignof(bool));

	printf("sizeof(Nat8) = %zu\n", sizeof(uint8_t));
	printf("alignof(Nat8) = %zu\n", __alignof(uint8_t));
	printf("sizeof(Nat16) = %zu\n", sizeof(uint16_t));
	printf("alignof(Nat16) = %zu\n", __alignof(uint16_t));
	printf("sizeof(Nat32) = %zu\n", sizeof(uint32_t));
	printf("alignof(Nat32) = %zu\n", __alignof(uint32_t));
	printf("sizeof(Nat64) = %zu\n", sizeof(uint64_t));
	printf("alignof(Nat64) = %zu\n", __alignof(uint64_t));
	printf("sizeof(Nat128) = %zu\n", sizeof(unsigned __int128));
	printf("alignof(Nat128) = %zu\n", __alignof(unsigned __int128));
	// type Nat256 not implemented
	//printf("sizeof(Nat256) = %zu\n", sizeof(Nat256))

	printf("sizeof(Int8) = %zu\n", sizeof(int8_t));
	printf("alignof(Int8) = %zu\n", __alignof(int8_t));
	printf("sizeof(Int16) = %zu\n", sizeof(int16_t));
	printf("alignof(Int16) = %zu\n", __alignof(int16_t));
	printf("sizeof(Int32) = %zu\n", sizeof(int32_t));
	printf("alignof(Int32) = %zu\n", __alignof(int32_t));
	printf("sizeof(Int64) = %zu\n", sizeof(int64_t));
	printf("alignof(Int64) = %zu\n", __alignof(int64_t));
	printf("sizeof(Int128) = %zu\n", sizeof(__int128));
	printf("alignof(Int128) = %zu\n", __alignof(__int128));
	// type Int256 not implemented
	//printf("sizeof(Int256) = %zu\n", sizeof(Int256))

	printf("sizeof(Char8) = %zu\n", sizeof(char));
	printf("alignof(Char8) = %zu\n", __alignof(char));
	printf("sizeof(Char16) = %zu\n", sizeof(char16_t));
	printf("alignof(Char16) = %zu\n", __alignof(char16_t));
	printf("sizeof(Char32) = %zu\n", sizeof(char32_t));
	printf("alignof(Char32) = %zu\n", __alignof(char32_t));

	// pointer size (for example pointer to []Char8)
	printf("sizeof(*Str8) = %zu\n", sizeof(char *));
	printf("alignof(*Str8) = %zu\n", __alignof(char *));

	// array size
	printf("sizeof([10]Int32) = %zu\n", sizeof(int32_t [10]));
	printf("alignof([10]Int32) = %zu\n", __alignof(int32_t [10]));

	printf("> alignof([3]Point) = %zu\n", __alignof(struct point [3]));


	// record size
	printf("sizeof(Point) = %zu\n", sizeof(struct point));
	printf("alignof(Point) = %zu\n", __alignof(struct point));

	//	printf("offsetof(Point.x) = %llu\n", Nat64 offsetof(Point.x))
	//	printf("offsetof(Point.y) = %llu\n", Nat64 offsetof(Point.y))


	printf("sizeof(Mixed1) = %zu\n", sizeof(struct mixed1));
	printf("alignof(Mixed1) = %zu\n", __alignof(struct mixed1));

	printf("sizeof(Mixed2) = %zu\n", sizeof(struct mixed2));
	printf("alignof(Mixed2) = %zu\n", __alignof(struct mixed2));


	//	printf("offsetof(Mixed2.i) = %llu\n", Nat64 offsetof(Mixed2.i))
	//	printf("offsetof(Mixed2.c) = %llu\n", Nat64 offsetof(Mixed2.c))
	//	printf("offsetof(Mixed2.f) = %llu\n", Nat64 offsetof(Mixed2.f))
	//	printf("offsetof(Mixed2.c2) = %llu\n", Nat64 offsetof(Mixed2.c2))
	//	printf("offsetof(Mixed2.m) = %llu\n", Nat64 offsetof(Mixed2.m))


	printf("sizeof(Mixed3) = %zu\n", sizeof(struct mixed3));
	printf("alignof(Mixed3) = %zu\n", __alignof(struct mixed3));

	printf("sizeof(Mixed4) = %zu\n", sizeof(struct mixed4));
	printf("alignof(Mixed4) = %zu\n", __alignof(struct mixed4));

	//	printf("offsetof(Mixed4.s) = %llu\n", Nat64 offsetof(Mixed4.s))
	//	printf("offsetof(Mixed4.c) = %llu\n", Nat64 offsetof(Mixed4.c))
	//	printf("offsetof(Mixed4.i) = %llu\n", Nat64 offsetof(Mixed4.i))
	//	printf("offsetof(Mixed4.f) = %llu\n", Nat64 offsetof(Mixed4.f))
	//	printf("offsetof(Mixed4.c2) = %llu\n", Nat64 offsetof(Mixed4.c2))
	//	printf("offsetof(Mixed4.i2) = %llu\n", Nat64 offsetof(Mixed4.i2))
	//	printf("offsetof(Mixed4.p) = %llu\n", Nat64 offsetof(Mixed4.p))
	//	printf("offsetof(Mixed4.s2) = %llu\n", Nat64 offsetof(Mixed4.s2))

	return 0;
}


