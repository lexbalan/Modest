// test/sizeof/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




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
    int32_t i;
    char c;
    double f;
    char c2[3];
    Mixed1 m;
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


//var s: Mixed2
static char c;
static int32_t i;
static double f;
static int16_t i2;
static Point p[3];
static bool g;

typedef struct {
    char c;
    int32_t i;
    double f;
    int16_t i2;
    Point p[3];
    bool g;
} X;

static X x;

int main()
{
    printf("test cast operation\n");

    const uint64_t start_adr = (uint64_t)&c;
    printf("off(c) = %llu\n", (uint64_t)&c - start_adr);
    printf("off(i) = %llu\n", (uint64_t)&i - start_adr);
    printf("off(f) = %llu\n", (uint64_t)&f - start_adr);
    printf("off(i2) = %llu\n", (uint64_t)&i2 - start_adr);
    printf("off(p) = %llu\n", (uint64_t)(Point *)&p - start_adr);
    printf("off(g) = %llu\n", (uint64_t)&g - start_adr);

    // дженерики в с явно не приводятся, но нектороые нужно!
    printf("offsetof(x.c) = %llu\n", ((uint64_t)(uint8_t)__offsetof(X, c)));
    printf("offsetof(x.i) = %llu\n", ((uint64_t)(uint8_t)__offsetof(X, i)));
    printf("offsetof(x.f) = %llu\n", ((uint64_t)(uint8_t)__offsetof(X, f)));
    printf("offsetof(x.i2) = %llu\n", ((uint64_t)(uint8_t)__offsetof(X, i2)));
    printf("offsetof(x.p) = %llu\n", ((uint64_t)(uint8_t)__offsetof(X, p)));
    printf("offsetof(x.g) = %llu\n", ((uint64_t)(uint8_t)__offsetof(X, g)));


    // sizeof(void) in C  == 1
    // sizeof(Unit) in CM == 0
    // TODO: here is a broblem
    printf("sizeof(Unit) = %llu\n", ((uint64_t)(uint8_t)sizeof(void)));
    printf("alignof(Unit) = %llu\n", ((uint64_t)(uint8_t)__alignof(void)));

    printf("sizeof(Bool) = %llu\n", ((uint64_t)(uint8_t)sizeof(bool)));
    printf("alignof(Bool) = %llu\n", ((uint64_t)(uint8_t)__alignof(bool)));

    printf("sizeof(Nat8) = %llu\n", ((uint64_t)(uint8_t)sizeof(uint8_t)));
    printf("alignof(Nat8) = %llu\n", ((uint64_t)(uint8_t)__alignof(uint8_t)));
    printf("sizeof(Nat16) = %llu\n", ((uint64_t)(uint8_t)sizeof(uint16_t)));
    printf("alignof(Nat16) = %llu\n", ((uint64_t)(uint8_t)__alignof(uint16_t)));
    printf("sizeof(Nat32) = %llu\n", ((uint64_t)(uint8_t)sizeof(uint32_t)));
    printf("alignof(Nat32) = %llu\n", ((uint64_t)(uint8_t)__alignof(uint32_t)));
    printf("sizeof(Nat64) = %llu\n", ((uint64_t)(uint8_t)sizeof(uint64_t)));
    printf("alignof(Nat64) = %llu\n", ((uint64_t)(uint8_t)__alignof(uint64_t)));
    printf("sizeof(Nat128) = %llu\n", ((uint64_t)(uint8_t)sizeof(unsigned __int128)));
    printf("alignof(Nat128) = %llu\n", ((uint64_t)(uint8_t)__alignof(unsigned __int128)));
    // type Nat256 not implemented
    //printf("sizeof(Nat256) = %llu\n", Nat64 sizeof(Nat256))

    printf("sizeof(Int8) = %llu\n", ((uint64_t)(uint8_t)sizeof(int8_t)));
    printf("alignof(Int8) = %llu\n", ((uint64_t)(uint8_t)__alignof(int8_t)));
    printf("sizeof(Int16) = %llu\n", ((uint64_t)(uint8_t)sizeof(int16_t)));
    printf("alignof(Int16) = %llu\n", ((uint64_t)(uint8_t)__alignof(int16_t)));
    printf("sizeof(Int32) = %llu\n", ((uint64_t)(uint8_t)sizeof(int32_t)));
    printf("alignof(Int32) = %llu\n", ((uint64_t)(uint8_t)__alignof(int32_t)));
    printf("sizeof(Int64) = %llu\n", ((uint64_t)(uint8_t)sizeof(int64_t)));
    printf("alignof(Int64) = %llu\n", ((uint64_t)(uint8_t)__alignof(int64_t)));
    printf("sizeof(Int128) = %llu\n", ((uint64_t)(uint8_t)sizeof(__int128)));
    printf("alignof(Int128) = %llu\n", ((uint64_t)(uint8_t)__alignof(__int128)));
    // type Int256 not implemented
    //printf("sizeof(Int256) = %llu\n", Nat64 sizeof(Int256))

    printf("sizeof(Char8) = %llu\n", ((uint64_t)(uint8_t)sizeof(char)));
    printf("alignof(Char8) = %llu\n", ((uint64_t)(uint8_t)__alignof(char)));
    printf("sizeof(Char16) = %llu\n", ((uint64_t)(uint8_t)sizeof(uint16_t)));
    printf("alignof(Char16) = %llu\n", ((uint64_t)(uint8_t)__alignof(uint16_t)));
    printf("sizeof(Char32) = %llu\n", ((uint64_t)(uint8_t)sizeof(uint32_t)));
    printf("alignof(Char32) = %llu\n", ((uint64_t)(uint8_t)__alignof(uint32_t)));

    // pointer size (for example pointer to []Char8)
    printf("sizeof(*Str8) = %llu\n", ((uint64_t)(uint8_t)sizeof(char *)));
    printf("alignof(*Str8) = %llu\n", ((uint64_t)(uint8_t)__alignof(char *)));

    // array size
    printf("sizeof([10]Int32) = %llu\n", ((uint64_t)(uint8_t)sizeof(int32_t[10])));
    printf("alignof([10]Int32) = %llu\n", ((uint64_t)(uint8_t)__alignof(int32_t[10])));

    printf("> alignof([3]Point) = %llu\n", ((uint64_t)(uint8_t)__alignof(Point[3])));



    // record size
    printf("sizeof(Point) = %llu\n", ((uint64_t)(uint8_t)sizeof(Point)));
    printf("alignof(Point) = %llu\n", ((uint64_t)(uint8_t)__alignof(Point)));

    printf("offsetof(Point.x) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Point, x)));
    printf("offsetof(Point.y) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Point, y)));


    printf("sizeof(Mixed1) = %llu\n", ((uint64_t)(uint8_t)sizeof(Mixed1)));
    printf("alignof(Mixed1) = %llu\n", ((uint64_t)(uint8_t)__alignof(Mixed1)));

    printf("sizeof(Mixed2) = %llu\n", ((uint64_t)(uint8_t)sizeof(Mixed2)));
    printf("alignof(Mixed2) = %llu\n", ((uint64_t)(uint8_t)__alignof(Mixed2)));


    printf("offsetof(Mixed2.i) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed2, i)));
    printf("offsetof(Mixed2.c) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed2, c)));
    printf("offsetof(Mixed2.f) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed2, f)));
    printf("offsetof(Mixed2.c2) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed2, c2)));
    printf("offsetof(Mixed2.m) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed2, m)));


    printf("sizeof(Mixed3) = %llu\n", ((uint64_t)(uint8_t)sizeof(Mixed3)));
    printf("alignof(Mixed3) = %llu\n", ((uint64_t)(uint8_t)__alignof(Mixed3)));

    printf("sizeof(Mixed4) = %llu\n", ((uint64_t)(uint8_t)sizeof(Mixed4)));
    printf("alignof(Mixed4) = %llu\n", ((uint64_t)(uint8_t)__alignof(Mixed4)));

    printf("offsetof(Mixed4.s) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed4, s)));
    printf("offsetof(Mixed4.c) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed4, c)));
    printf("offsetof(Mixed4.i) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed4, i)));
    printf("offsetof(Mixed4.f) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed4, f)));
    printf("offsetof(Mixed4.c2) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed4, c2)));
    printf("offsetof(Mixed4.i2) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed4, i2)));
    printf("offsetof(Mixed4.p) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed4, p)));
    printf("offsetof(Mixed4.s2) = %llu\n", ((uint64_t)(uint8_t)__offsetof(Mixed4, s2)));

    return 0;
}

