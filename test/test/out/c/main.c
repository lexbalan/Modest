// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



// 1. Сначала проходит по всем сущностям и создает type_undefined/value_undefined
struct Node;
typedef struct Node Node;



struct Node {
	Node *next;
	void *data;
};
//: []()->Unit

static void init();

static void *funcs[1] = (void *[1]){&init};

int32_t main()
{
	init();

	Node n;

	return 0;
}

static void init()
{
	printf("init()\n");
}

