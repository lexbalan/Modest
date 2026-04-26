
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
typedef int32_t main_MyInt32;
#define MY_ZERO ((main_MyInt32)0)
#define MY_ONE ((main_MyInt32)1)
typedef main_MyInt32 main_MyInt32_2;
typedef main_MyInt32 main_MyInt32_3;
#define MAIN_CVB 0
static volatile int32_t main_vvb = 1;
struct main_protocol_header {
	uint16_t start;
	uint16_t len;
};
static bool name2;
static bool name22;
extern int32_t main_ext;
extern int32_t main_ext_arr[];
__attribute__((aligned(8), section("__DATA, .xdata")))
static uint32_t main_x;
uint16_t main_s;
__attribute__((used))
static uint64_t main_u;
__attribute__((unused))
static uint64_t main_u2;
static uint32_t *restrict main_rp;
static volatile bool main_vb[32];

__attribute__((always_inline))
static inline int32_t main_staticInlineFunc(int32_t x) {
	return x + 1;
}

__attribute__((noinline))
static int32_t main_staticNoinlineFunc(int32_t x) {
	return x + 1;
}

static int32_t main_staticInlineHintFunc(int32_t x) {
	return x + 1;
}
struct main_point2_d {
	double x;
	double y;
};

static void main_hello(void) {
	printf("hi!\n");
}

int32_t main(void) {
	static uint32_t staticCounter = 0U;
	main_hello();
	printf("Attributes example\n");
	(void)main_staticInlineFunc(0);
	(void)main_staticNoinlineFunc(0);
	(void)main_staticInlineHintFunc(0);
	return 0;
}

