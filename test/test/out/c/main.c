// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



struct Node;
typedef struct Node Node;
struct DataHolder;
typedef struct DataHolder DataHolder;



struct Node {
	Node *next;
	DataHolder *data;
};

struct DataHolder {
	int32_t data;
};
static void init();
static void foo();

static void *funcs[2] = (void *[2]){&init, &foo};
static void *a = &init;
static void *b = &foo;

typedef int32_t SonrState;

static void xx(SonrState *x)
{
}

int32_t main()
{
	init();
	foo();

	Node n;

	return 0;
}

static void init()
{
	printf("init()\n");
}

static void foo()
{
	printf("foo()\n");
}

static int32_t add(int32_t a, int32_t b)
{
	return a + b;
}

