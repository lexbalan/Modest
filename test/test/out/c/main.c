
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>


#include <stdlib.h>




//@property("type.generic", True)
typedef void *DataPtr;


struct Node;
typedef struct Node Node;

struct Node {
	Node *next;
	Node *prev;
	DataPtr data;
};


static Node *create()
{
	Node *n = malloc(sizeof(Node));
	return n;
}


int32_t main()
{
	Node *n = create();

	if (n == NULL) {
		printf("error: cannot allocate memory\n");
		return -1;
	}

	n->data = malloc(sizeof(int32_t[10][10]));

	if (n->data == NULL) {
		printf("error: cannot allocate memory\n");
		return -1;
	}


	return 0;
}

