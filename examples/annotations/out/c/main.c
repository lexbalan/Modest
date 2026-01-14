
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



typedef int32_t MyInt32;

#define MY_ZERO  ((MyInt32)0)

#define MY_ONE  ((MyInt32)1)


// These refined MyInt32 types are compatible with MyInt32
// but not compatible with anything else (e.g. between them)
typedef MyInt32 MyInt32_2;
typedef MyInt32 MyInt32_3;

#define CVB  (0)
static int32_t vvb = 1;

struct __attribute__((packed)) ProtocolHeader {
	uint16_t start;
	uint16_t len;
};
typedef struct ProtocolHeader ProtocolHeader;

static bool name2;

static bool name22;

extern int32_t ext;

extern int32_t ext_arr[];

__attribute__((section("__DATA, .xdata")))
__attribute__((aligned(8)))
static uint32_t x;

uint16_t s;

__attribute__((used))
static uint64_t u;

__attribute__((unused))
static uint64_t u2;

static uint32_t *restrict rp;
static volatile bool vb[32];

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



// переопределение f не вызвало ошибку!
static void hello(void) {
	printf("hi!\n");
}


int32_t main(void) {
	hello();
	printf("Attributes example\n");
	(void)staticInlineFunc(0);
	(void)staticNoinlineFunc(0);
	(void)staticInlineHintFunc(0);
	return 0;
}


