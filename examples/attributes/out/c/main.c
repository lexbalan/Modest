// examples/attributes/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


/* anonymous records */
struct __anonymous_struct_1 {
	uint16_t start;
	uint16_t len;
};

typedef int32_t MyInt32;

#define MY_ZERO  ((MyInt32)0)

#define MY_ONE  ((MyInt32)1)

// These refined MyInt32 types are compatible with MyInt32
// but not compatible with anything else (e.g. between them)
typedef MyInt32 MyInt32_2;
typedef MyInt32 MyInt32_3;

struct __attribute__((packed)) ProtocolHeader {
	uint16_t start;
	uint16_t len;
};
typedef struct ProtocolHeader ProtocolHeader;

static bool name2;

static bool name22;

extern int32_t ext;

__attribute__((section("__DATA, .xdata")))
__attribute__((aligned(8)))
static uint32_t x;

uint16_t s;

__attribute__((used))
static uint64_t u;

__attribute__((unused))
static uint64_t u2;

__attribute__((always_inline))
static inline int32_t staticInlineFunc(int32_t x) {
	return x + 1;
}

__attribute__((noinline))
static int32_t staticNoinlineFunc(int32_t x) {
	return x + 1;
}

static inline int32_t staticInlineHintFunc(int32_t x) {
	return x + 1;
}

struct Point2D {
	double x;
	double y;
};
typedef struct Point2D Point2D;

int main() {
	printf("Attributes example\n");
	return 0;
}

