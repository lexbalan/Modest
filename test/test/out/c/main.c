// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"




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

