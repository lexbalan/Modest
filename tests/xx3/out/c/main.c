
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



typedef struct context *ContextHandler(struct context *x);

struct x {
	struct context *c;
};

// си не позволяет создавать укзаатель на массив с элементами неполного типа
// вообще странно - но вот так
//type A = *[1]Context
//var a: *[1]Context


struct context;
static struct context *p;

struct context {
	int32_t x;
	int32_t y;
	ContextHandler *f;
};

struct zx {
	int32_t x;
	struct context c;
	ContextHandler *f;
};

int32_t main(void) {
	#define f  3.14
	double fx = (double)f;
	fx = (double)f / 3.0;
	fx = (double)f * 2.0;
	fx = 2.0;
	double k = (double)(2.0 / 3.0);
	printf("%f\n", (double)k);
	return 0;

#undef f
}


