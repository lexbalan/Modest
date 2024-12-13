// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



// 1. Сначала проходит по всем сущностям и создает type_undefined/value_undefinedstruct Node;
typedef struct Node Node;



struct Node {
	Node *next;
	void *data;
};
//: []()->Unit
//var a: []Int32 = [10, "&add", 20, 30, "sd"]
static void init();
static void foo();

static void *funcs[2] = (void *[2]){&init, &foo};

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

