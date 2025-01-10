
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>


#include <stdlib.h>





typedef int32_t *DataPtr;


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


static char *table[2][2] = (char *[2][2]){
	"A", "B",
	"C", "D"
};

static void tablePrint(char *(*table)[][], int32_t n, int32_t m)
{
}

int32_t main()
{
	Node *n = create();

	int16_t *e = NULL;

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

