
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#include <stdio.h>


struct main_Point {
	uint32_t x;
	uint32_t y;
};
typedef struct main_Point main_Point;

struct main_Mixed1 {
	char c;
	int32_t i;
	double f;
};
typedef struct main_Mixed1 main_Mixed1;

struct main_Mixed2 {
	int32_t i;
	char c;
	double f;
	char c2[3];
	main_Mixed1 m;
};
typedef struct main_Mixed2 main_Mixed2;

struct main_Mixed3 {
	char c;
	int32_t i;
	double f;
	char c2[9];
};
typedef struct main_Mixed3 main_Mixed3;

struct main_Mixed4 {
	main_Mixed2 s;
	char c;
	int32_t i;
	double f;
	char c2[9];
	int16_t i2;
	main_Point p[3];
	main_Mixed3 s2;
};
typedef struct main_Mixed4 main_Mixed4;


//var s: Mixed2
static char main_c;
static int32_t main_i;
static double main_f;
static int16_t main_i2;
static main_Point main_p[3];
static bool main_g;

struct main_X {
	char c;
	int32_t i;
	double f;
	int16_t i2;
	main_Point p[3];
	bool g;
};
typedef struct main_X main_X;

static main_X main_x;

int main()
{
	printf("test cast operation\n");

	uint64_t start_adr = (uint64_t)&main_c;
	printf("off(c) = %llu\n", (uint64_t)&main_c - start_adr);
	printf("off(i) = %llu\n", (uint64_t)&main_i - start_adr);
	printf("off(f) = %llu\n", (uint64_t)&main_f - start_adr);
	printf("off(i2) = %llu\n", (uint64_t)&main_i2 - start_adr);
	printf("off(p) = %llu\n", (uint64_t)&main_p - start_adr);
	printf("off(g) = %llu\n", (uint64_t)&main_g - start_adr);

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
	printf("sizeof(Unit) = %llu\n", (uint64_t)sizeof(void));
	printf("alignof(Unit) = %llu\n", (uint64_t)__alignof(void));

	printf("sizeof(Bool) = %llu\n", (uint64_t)sizeof(bool));
	printf("alignof(Bool) = %llu\n", (uint64_t)__alignof(bool));

	printf("sizeof(Nat8) = %llu\n", (uint64_t)sizeof(uint8_t));
	printf("alignof(Nat8) = %llu\n", (uint64_t)__alignof(uint8_t));
	printf("sizeof(Nat16) = %llu\n", (uint64_t)sizeof(uint16_t));
	printf("alignof(Nat16) = %llu\n", (uint64_t)__alignof(uint16_t));
	printf("sizeof(Nat32) = %llu\n", (uint64_t)sizeof(uint32_t));
	printf("alignof(Nat32) = %llu\n", (uint64_t)__alignof(uint32_t));
	printf("sizeof(Nat64) = %llu\n", (uint64_t)sizeof(uint64_t));
	printf("alignof(Nat64) = %llu\n", (uint64_t)__alignof(uint64_t));
	printf("sizeof(Nat128) = %llu\n", (uint64_t)sizeof(unsigned __int128));
	printf("alignof(Nat128) = %llu\n", (uint64_t)__alignof(unsigned __int128));
	// type Nat256 not implemented
	//printf("sizeof(Nat256) = %llu\n", Nat64 sizeof(Nat256))

	printf("sizeof(Int8) = %llu\n", (uint64_t)sizeof(int8_t));
	printf("alignof(Int8) = %llu\n", (uint64_t)__alignof(int8_t));
	printf("sizeof(Int16) = %llu\n", (uint64_t)sizeof(int16_t));
	printf("alignof(Int16) = %llu\n", (uint64_t)__alignof(int16_t));
	printf("sizeof(Int32) = %llu\n", (uint64_t)sizeof(int32_t));
	printf("alignof(Int32) = %llu\n", (uint64_t)__alignof(int32_t));
	printf("sizeof(Int64) = %llu\n", (uint64_t)sizeof(int64_t));
	printf("alignof(Int64) = %llu\n", (uint64_t)__alignof(int64_t));
	printf("sizeof(Int128) = %llu\n", (uint64_t)sizeof(__int128));
	printf("alignof(Int128) = %llu\n", (uint64_t)__alignof(__int128));
	// type Int256 not implemented
	//printf("sizeof(Int256) = %llu\n", Nat64 sizeof(Int256))

	printf("sizeof(Char8) = %llu\n", (uint64_t)sizeof(char));
	printf("alignof(Char8) = %llu\n", (uint64_t)__alignof(char));
	printf("sizeof(Char16) = %llu\n", (uint64_t)sizeof(uint16_t));
	printf("alignof(Char16) = %llu\n", (uint64_t)__alignof(uint16_t));
	printf("sizeof(Char32) = %llu\n", (uint64_t)sizeof(uint32_t));
	printf("alignof(Char32) = %llu\n", (uint64_t)__alignof(uint32_t));

	// pointer size (for example pointer to []Char8)
	printf("sizeof(*Str8) = %llu\n", (uint64_t)sizeof(char *));
	printf("alignof(*Str8) = %llu\n", (uint64_t)__alignof(char *));

	// array size
	printf("sizeof([10]Int32) = %llu\n", (uint64_t)sizeof(int32_t[10]));
	printf("alignof([10]Int32) = %llu\n", (uint64_t)__alignof(int32_t[10]));

	printf("> alignof([3]Point) = %llu\n", (uint64_t)__alignof(main_Point[3]));


	// record size
	printf("sizeof(Point) = %llu\n", (uint64_t)sizeof(main_Point));
	printf("alignof(Point) = %llu\n", (uint64_t)__alignof(main_Point));

	//	printf("offsetof(Point.x) = %llu\n", Nat64 offsetof(Point.x))
	//	printf("offsetof(Point.y) = %llu\n", Nat64 offsetof(Point.y))


	printf("sizeof(Mixed1) = %llu\n", (uint64_t)sizeof(main_Mixed1));
	printf("alignof(Mixed1) = %llu\n", (uint64_t)__alignof(main_Mixed1));

	printf("sizeof(Mixed2) = %llu\n", (uint64_t)sizeof(main_Mixed2));
	printf("alignof(Mixed2) = %llu\n", (uint64_t)__alignof(main_Mixed2));


	//	printf("offsetof(Mixed2.i) = %llu\n", Nat64 offsetof(Mixed2.i))
	//	printf("offsetof(Mixed2.c) = %llu\n", Nat64 offsetof(Mixed2.c))
	//	printf("offsetof(Mixed2.f) = %llu\n", Nat64 offsetof(Mixed2.f))
	//	printf("offsetof(Mixed2.c2) = %llu\n", Nat64 offsetof(Mixed2.c2))
	//	printf("offsetof(Mixed2.m) = %llu\n", Nat64 offsetof(Mixed2.m))


	printf("sizeof(Mixed3) = %llu\n", (uint64_t)sizeof(main_Mixed3));
	printf("alignof(Mixed3) = %llu\n", (uint64_t)__alignof(main_Mixed3));

	printf("sizeof(Mixed4) = %llu\n", (uint64_t)sizeof(main_Mixed4));
	printf("alignof(Mixed4) = %llu\n", (uint64_t)__alignof(main_Mixed4));

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

