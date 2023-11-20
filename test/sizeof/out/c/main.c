
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/sizeof/main.cm


typedef struct {
    uint32_t x;
    uint32_t y;
} Point;

typedef struct {
    char c;
    int32_t i;
    double f;
} Mixed1;

typedef struct {
    char c;
    int32_t i;
    double f;
    char c2;
} Mixed2;

typedef struct {
    char c;
    int32_t i;
    double f;
    char c2[9];
} Mixed3;

typedef struct {
    Mixed2 s;
    char c;
    int32_t i;
    double f;
    char c2[9];
    int16_t i2;
    Point p[3];
    Mixed3 s2;
} Mixed4;


int main(void)
{
    printf("test cast operation\n");

    // sizeof(void) in C  == 1
    // sizeof(Unit) in CM == 0
    // TODO: here is a broblem
    printf("sizeof(Unit) = %lu\n", sizeof(void));
    printf("alignof(Unit) = %lu\n", __alignof(void));

    printf("sizeof(Bool) = %lu\n", sizeof(bool));
    printf("alignof(Bool) = %lu\n", __alignof(bool));

    printf("sizeof(Nat8) = %lu\n", sizeof(uint8_t));
    printf("alignof(Nat8) = %lu\n", __alignof(uint8_t));
    printf("sizeof(Nat16) = %lu\n", sizeof(uint16_t));
    printf("alignof(Nat16) = %lu\n", __alignof(uint16_t));
    printf("sizeof(Nat32) = %lu\n", sizeof(uint32_t));
    printf("alignof(Nat32) = %lu\n", __alignof(uint32_t));
    printf("sizeof(Nat64) = %lu\n", sizeof(uint64_t));
    printf("alignof(Nat64) = %lu\n", __alignof(uint64_t));
    printf("sizeof(Nat128) = %lu\n", sizeof(unsigned __int128));
    printf("alignof(Nat128) = %lu\n", __alignof(unsigned __int128));
    // type Nat256 not implemented
    //printf("sizeof(Nat256) = %lu\n", sizeof(Nat256) to Nat64)

    printf("sizeof(Int8) = %lu\n", sizeof(int8_t));
    printf("alignof(Int8) = %lu\n", __alignof(int8_t));
    printf("sizeof(Int16) = %lu\n", sizeof(int16_t));
    printf("alignof(Int16) = %lu\n", __alignof(int16_t));
    printf("sizeof(Int32) = %lu\n", sizeof(int32_t));
    printf("alignof(Int32) = %lu\n", __alignof(int32_t));
    printf("sizeof(Int64) = %lu\n", sizeof(int64_t));
    printf("alignof(Int64) = %lu\n", __alignof(int64_t));
    printf("sizeof(Int128) = %lu\n", sizeof(__int128));
    printf("alignof(Int128) = %lu\n", __alignof(__int128));
    // type Int256 not implemented
    //printf("sizeof(Int256) = %lu\n", sizeof(Int256) to Nat64)

    printf("sizeof(Char8) = %lu\n", sizeof(char));
    printf("alignof(Char8) = %lu\n", __alignof(char));
    printf("sizeof(Char16) = %lu\n", sizeof(uint16_t));
    printf("alignof(Char16) = %lu\n", __alignof(uint16_t));
    printf("sizeof(Char32) = %lu\n", sizeof(uint32_t));
    printf("alignof(Char32) = %lu\n", __alignof(uint32_t));

    // pointer size (for example pointer to []Char8)
    printf("sizeof(*Str8) = %lu\n", sizeof(char *));
    printf("alignof(*Str8) = %lu\n", __alignof(char *));

    // array size
    printf("sizeof([10]Int32) = %lu\n", sizeof(int32_t [10]));
    printf("alignof([10]Int32) = %lu\n", __alignof(int32_t [10]));

    printf("> alignof([3]Point) = %lu\n", __alignof(Point [3]));



    // record size
    printf("sizeof(Point) = %lu\n", sizeof(Point));
    printf("alignof(Point) = %lu\n", __alignof(Point));

    printf("offsetof(Point.x) = %lu\n", __offsetof(Point, x));
    printf("offsetof(Point.y) = %lu\n", __offsetof(Point, y));


    printf("sizeof(Mixed1) = %lu\n", sizeof(Mixed1));
    printf("alignof(Mixed1) = %lu\n", __alignof(Mixed1));

    printf("sizeof(Mixed2) = %lu\n", sizeof(Mixed2));
    printf("alignof(Mixed2) = %lu\n", __alignof(Mixed2));

    printf("sizeof(Mixed3) = %lu\n", sizeof(Mixed3));
    printf("alignof(Mixed3) = %lu\n", __alignof(Mixed3));

    printf("sizeof(Mixed4) = %lu\n", sizeof(Mixed4));
    printf("alignof(Mixed4) = %lu\n", __alignof(Mixed4));

    printf("offsetof(Mixed4.s) = %lu\n", __offsetof(Mixed4, s));
    printf("offsetof(Mixed4.c) = %lu\n", __offsetof(Mixed4, c));
    printf("offsetof(Mixed4.i) = %lu\n", __offsetof(Mixed4, i));
    printf("offsetof(Mixed4.f) = %lu\n", __offsetof(Mixed4, f));
    printf("offsetof(Mixed4.c2) = %lu\n", __offsetof(Mixed4, c2));
    printf("offsetof(Mixed4.i2) = %lu\n", __offsetof(Mixed4, i2));
    printf("offsetof(Mixed4.p) = %lu\n", __offsetof(Mixed4, p));
    printf("offsetof(Mixed4.s2) = %lu\n", __offsetof(Mixed4, s2));

    return 0;
}

