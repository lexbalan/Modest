
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#if !defined(__STR_UNICODE__)
#define __STR_UNICODE__
typedef uint8_t char8_t;
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#define __STR8(x) x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x) __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#endif
struct main_point {
	uint32_t x;
	uint32_t y;
};
struct main_mixed1 {
	char c;
	int32_t i;
	double f;
};
struct main_mixed2 {
	int32_t i;
	char c;
	double f;
	char c2[3];
	struct main_mixed1 m;
};
struct main_mixed3 {
	char c;
	int32_t i;
	double f;
	char c2[9];
};
struct main_mixed4 {
	struct main_mixed2 s;
	char c;
	int32_t i;
	double f;
	char c2[9];
	int16_t i2;
	struct main_point p[3];
	struct main_mixed3 s2;
};
static char main_c;
static int32_t main_i;
static double main_f;
static int16_t main_i2;
static struct main_point main_p[3];
static bool main_g;
struct main_x {
	char c;
	int32_t i;
	double f;
	int16_t i2;
	struct main_point p[3];
	bool g;
};
static struct main_x main_x;

int main(void) {
	printf("test cast operation\n");
	const uint64_t start_adr = (uint64_t)&main_c;
	printf("off(c) = %llu\n", (uint64_t)&main_c - start_adr);
	printf("off(i) = %llu\n", (uint64_t)&main_i - start_adr);
	printf("off(f) = %llu\n", (uint64_t)&main_f - start_adr);
	printf("off(i2) = %llu\n", (uint64_t)&main_i2 - start_adr);
	printf("off(p) = %llu\n", (uint64_t)&main_p - start_adr);
	printf("off(g) = %llu\n", (uint64_t)&main_g - start_adr);
	printf("sizeof(Unit) = %zu\n", (size_t)0);
	printf("alignof(Unit) = %zu\n", (size_t)1);
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
	printf("sizeof(Char8) = %zu\n", sizeof(char));
	printf("alignof(Char8) = %zu\n", __alignof(char));
	printf("sizeof(Char16) = %zu\n", sizeof(char16_t));
	printf("alignof(Char16) = %zu\n", __alignof(char16_t));
	printf("sizeof(Char32) = %zu\n", sizeof(char32_t));
	printf("alignof(Char32) = %zu\n", __alignof(char32_t));
	printf("sizeof(*Str8) = %zu\n", sizeof(char *));
	printf("alignof(*Str8) = %zu\n", __alignof(char *));
	printf("sizeof([10]Int32) = %zu\n", sizeof(int32_t [10]));
	printf("alignof([10]Int32) = %zu\n", __alignof(int32_t [10]));
	printf("> alignof([3]Point) = %zu\n", __alignof(struct main_point [3]));
	printf("sizeof(Point) = %zu\n", sizeof(struct main_point));
	printf("alignof(Point) = %zu\n", __alignof(struct main_point));
	printf("sizeof(Mixed1) = %zu\n", sizeof(struct main_mixed1));
	printf("alignof(Mixed1) = %zu\n", __alignof(struct main_mixed1));
	printf("sizeof(Mixed2) = %zu\n", sizeof(struct main_mixed2));
	printf("alignof(Mixed2) = %zu\n", __alignof(struct main_mixed2));
	printf("sizeof(Mixed3) = %zu\n", sizeof(struct main_mixed3));
	printf("alignof(Mixed3) = %zu\n", __alignof(struct main_mixed3));
	printf("sizeof(Mixed4) = %zu\n", sizeof(struct main_mixed4));
	printf("alignof(Mixed4) = %zu\n", __alignof(struct main_mixed4));
	return 0;
}

