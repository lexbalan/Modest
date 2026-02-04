
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



typedef struct context *ContextHandler(struct context *x);

struct x {
	struct context *c;
};

//type A = *[1]Context


struct context;
static struct context (*a)[1];


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
	return 0;
}


