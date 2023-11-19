
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/sizeof/main.cm


typedef struct {
    uint32_t x;
    uint32_t y;
} Point;

int main(void)
{
    printf("test cast operation\n");

    // sizeof(void) in C  == 1
    // sizeof(Unit) in CM == 0
    // TODO: here is a broblem
    printf("sizeof(Unit) = %lu\n", sizeof(void));

    printf("sizeof(Bool) = %lu\n", sizeof(bool));

    printf("sizeof(Nat8) = %lu\n", sizeof(uint8_t));
    printf("sizeof(Nat16) = %lu\n", sizeof(uint16_t));
    printf("sizeof(Nat32) = %lu\n", sizeof(uint32_t));
    printf("sizeof(Nat64) = %lu\n", sizeof(uint64_t));
    printf("sizeof(Nat128) = %lu\n", sizeof(unsigned __int128));
    // type Nat256 not implemented
    //printf("sizeof(Nat256) = %lu\n", sizeof(Nat256) to Nat64)

    printf("sizeof(Int8) = %lu\n", sizeof(int8_t));
    printf("sizeof(Int16) = %lu\n", sizeof(int16_t));
    printf("sizeof(Int32) = %lu\n", sizeof(int32_t));
    printf("sizeof(Int64) = %lu\n", sizeof(int64_t));
    printf("sizeof(Int128) = %lu\n", sizeof(__int128));
    // type Int256 not implemented
    //printf("sizeof(Int256) = %lu\n", sizeof(Int256) to Nat64)

    printf("sizeof(Char8) = %lu\n", sizeof(char));
    printf("sizeof(Char16) = %lu\n", sizeof(uint16_t));
    printf("sizeof(Char32) = %lu\n", sizeof(uint32_t));

    // pointer size (for example pointer to []Char8)
    printf("sizeof(*Str8) = %lu\n", sizeof(char *));

    // array size
    printf("sizeof([10]Int32) = %lu\n", sizeof(int32_t [10]));

    // record size
    printf("sizeof(Point) = %lu\n", sizeof(Point));


    return 0;
}

