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

int32_t main()
{
	Node n;
	return 0;
}

